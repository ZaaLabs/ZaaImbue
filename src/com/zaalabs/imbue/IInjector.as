/*******************************************************************************
 * ZaaImbue
 * Copyright (c) 2011 ZaaLabs, Ltd.
 * For more information see http://www.zaalabs.com
 *
 * This file is licensed under the terms of the MIT license, which is included
 * in the license.txt file at the root directory of this library.
 ******************************************************************************/
package com.zaalabs.imbue
{
    /**
     * IInjector is an interface that specifies a simple Dependency
     * Injection API.
     *
     * Features in this simple DI framework include metadata based
     * injections.
     *
     */
    public interface IInjector
    {
        /**
         * Maps a value to a certain class, so when <code>apply()</code>
         * is called, the value will be injected into any property with the
         * [Inject] tag over it and that matches the class definition specified
         * in the <code>toClass</code> parameter.
         *
         * @param value The dependency that will be injected
         * @param toClass The class that the dependency will be injected into
         */
        function mapValue(value:Object, toClass:Class):void;

        /**
         * Applies the injection to the specified object. If you wish to have a
         * property injected into the specified object, make sure that an [Inject]
         * metadata tag is added to the desired target property and the value is
         * mapped in this injector using the <code>mapValue()</code> method.
         *
         * @param value the object that will be injected
         */
        function apply(value:Object):void;
    }
}