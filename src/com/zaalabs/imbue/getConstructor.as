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
    import flash.utils.Proxy;
    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;

    /**
     * This is a clever discovery in the SwiftSuspenders library, so I copied it :P
     *
     * Basically, some classes throw exeptions and such when we try to get the
     * constructor, so canstructor getting is then abstracted, and a simple is
     * check is used to see if we can get the costructor or use the more costly
     * <code>getQualifiedClassName()</code> method to get the class definition
     *
     * @param value
     * @return
     */
    public function getConstructor(value:Object):Class
    {
        if (value is Proxy || value is Number || value is XML || value is XMLList)
        {
            var qname:String = getQualifiedClassName(value);
            return Class(getDefinitionByName(qname));
        }
        
        return value.constructor;
    }
}