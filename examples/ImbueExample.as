/*******************************************************************************
 * ZaaImbue
 * Copyright (c) 2011 ZaaLabs, Ltd.
 * For more information see http://www.zaalabs.com
 *
 * This file is licensed under the terms of the MIT license, which is included
 * in the license.txt file at the root directory of this library.
 ******************************************************************************/
package
{
    import com.zaalabs.imbue.IInjector;
    import com.zaalabs.imbue.Injector;

    import flash.display.Sprite;

    public class ImbueExample extends Sprite
    {

        [Inject] // this will inject an instance of ExampleClass into this property
        public var myFirstInjectedInstance:ExampleClass;

        [Inject] // this will inject an instance of AnotherExampleClass into this property
        public var mySecondInjectedInstance:AnotherExampleClass;

        public function ImbueExample()
        {
            // create an instance of the classes we want to inject
            var myLocalMember:ExampleClass = new ExampleClass();
            var anotherLocalMember:AnotherExampleClass = new AnotherExampleClass();

            // This is actually all it takes to inject something
            var injector:IInjector = new Injector();
            injector.mapValue(myLocalMember, ExampleClass);
            injector.mapValue(anotherLocalMember, AnotherExampleClass);
            // apply the injections!
            injector.apply(this);
        }

        [PostInject]
        // This gets called after an injection has occurred on the target
        public function onPostInject():void
        {
            trace("We are all done injecting, now we can use our instance!");
            trace("Name of first injected instance:", myFirstInjectedInstance.name);
            trace("Name of second injected instance:", mySecondInjectedInstance.name)
        }

    }
}


