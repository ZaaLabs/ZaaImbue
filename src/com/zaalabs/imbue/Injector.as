package com.zaalabs.imbue
{
    import flash.utils.Dictionary;
    import flash.utils.describeType;
    import flash.utils.getDefinitionByName;

    /**
     * The Default implementation for the IInjector interface. It provides
     * some basic functionality for getting an dependency injection system
     * going. Nothing fancy or magical going on here, Pretty straightforward
     */
    public class Injector implements IInjector
    {

        /**
         * @inheritDoc
         */
        public function mapValue(value:Object, toClass:Class):void
        {
            mappedValues[toClass] = value;
        }

        /**
         * @inheritDoc
         */
        public function apply(value:Object):void
        {
            var definition:Class = getConstructor(value);
            var targets:Vector.<InjectionTarget> = getInjectionTargets(definition) as Vector.<InjectionTarget>;
            var postConstruct:Vector.<PostInjectionTarget> = getPostConstructTargets(definition) as Vector.<PostInjectionTarget>;

            // apply injections to each target
            for each(var target:InjectionTarget in targets) {
                applyToTarget(target,value);
            }

            if(targets.length)
            {
                // apply post construct
                for each(var pcTarget:PostInjectionTarget in postConstruct)
                {
                    var f:Function = value[pcTarget.method];
                    if(f != null) f();
                }
            }
        }

        //_____________________________________________________________________
        //	Constructor
        //_____________________________________________________________________
        public function Injector()
        {
            // Initialize the member properties
            mappedValues = new Dictionary();
        }

        //_____________________________________________________________________
        //	Protected Properties
        //_____________________________________________________________________
        /**
         * @private
         */
        protected var mappedValues:Dictionary;

        /**
         * @private
         */
        protected static var definitionCache:Dictionary = new Dictionary();

        /**
         * @private
         */
        protected static var injectionTargetCache:Dictionary = new Dictionary();

        /**
         * @private
         */
        protected static var postConstructTargetCache:Dictionary = new Dictionary();

        //_____________________________________________________________________
        //	Protected methods
        //_____________________________________________________________________
        /**
         * Returns InjectionTargets for the specified class, from either a cached
         * instance or calculated on demand. This function also stores caches for
         * DescribeType calls.
         *
         * Structuring calls this way makes the Injectors api more extendable by
         * exposing our caching mechanisms and abstracting it.
         *
         * @param value
         * @return
         */
        public static function getInjectionTargets(value:Class):Vector.<InjectionTarget>
        {
            // Return it is we have it in the cache
            if (injectionTargetCache[value])
            {
                return injectionTargetCache[value] as Vector.<InjectionTarget>;
            }

            // Look over the xml type definition and create injector targets
            var result:Vector.<InjectionTarget> = new Vector.<InjectionTarget>();

            // do a describe type if it is not in the cache
            if (!definitionCache[value])
                definitionCache[value] = describeType(value);

            var definition:XML = definitionCache[value];
            var target:InjectionTarget;

            for each (var node:XML in definition.factory.*.(name() == 'variable' || name() == 'accessor').metadata.(@name == 'Inject'))
            {
                target = new InjectionTarget();
                target.property = node.parent().@name;
                target.definition = getDefinitionByName(node.parent().@type) as Class;
                target.uri = node.parent().@uri;
                result.push(target);
            }

            return result;
        }

        public static function getPostConstructTargets(value:Class):Vector.<PostInjectionTarget>
        {
            // try to find it in the cache
            if(postConstructTargetCache[value])
            {
                return postConstructTargetCache[value] as Vector.<PostInjectionTarget>;
            }

            // Look over the xml type definition and create injector targets
            var result:Vector.<PostInjectionTarget> = new Vector.<PostInjectionTarget>();

            // do a describe type if it is not in the cache
            if (!definitionCache[value])
                definitionCache[value] = describeType(value);

            var definition:XML = definitionCache[value];
            var target:PostInjectionTarget;

            for each (var node:XML in definition.factory.*.(name() == 'method').metadata.(@name == 'PostInject')) {
                target = new PostInjectionTarget();
                target.method = node.parent().@name;
                result.push(target);
            }

            return result;
        }

        protected function applyToTarget(target:InjectionTarget,value:Object):void
        {
            var injectedValue:Object = mappedValues[target.definition];

            if(!injectedValue) return;

            if(target.uri.length == 0)
            {
                // Inject the regular way
                value[target.property] = injectedValue;
            }
        }
    }
}