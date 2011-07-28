Dungdungdung object factory and databinding.
============================================

Dungdungdung implements actionscript bindings for 
`django-easymode <http://packages.python.org/django-easymode/>`_. It combines 
databinding and object creation by implementing a map from XML to actionscript
objects. While it is specifically designed to work with the XML outputted by
django-easymode, it can be used with any backend, as long as a specific structure
of XML is maintained. Dungdungdung uses 
`Swiftsuspenders <http://github.com/tschneidereit/SwiftSuspenders>`_ for
`dependency injection <http://c2.com/cgi/wiki?DependencyInjection>`_ which is also
used in the `robotlegs framework <http://www.robotlegs.org/>`_.

The api docs are at http://specialunderwear.github.com/robotlegs-dungdungdung.

XML structure
-------------

Create an xml with a structure similar to this one. This is the type of xml that
is produced by django-easymode::

    <root>
        <pages>
            <page>
                <name>Homepage</name>
                <title>Home</title>
                <!-- children marks child objects need to be created -->
                <children>
                    <textblock>
                        <text>
                            Ut nulla. Vivamus bibendum, nulla ut congue fringilla,
                            lorem ipsum ultricies risus, ut rutrum velit tortor vel
                            purus. In hac habitasse platea dictumst. Duis fermentum,
                            metus sed congue gravida, arcu dui ornare urna.
                        </text>
                        <font>Arial</font>
                    </textblock>
                    <imageviewer>
                        <children>
                            <image>
                                <description>What a pretty image indeed</description>
                                <url><a href="prettyimage.jpg"/></url>
                            </image>
                            <image>
                                <description>What an ugly image indeed</description>
                                <url><a href="uglyimage.jpg"/></url>
                            </image>
                        </children>
                    </imageviewer>
                </children>
            </page>
            <!-- more pages go here -->
        </pages>
    </root>

In the xml you can identify *lists*, *objects* and *properties*. In the above
example, *pages* is a *list*, *page* is an *object* and *name* and *title* are
*properties*. Going further, *children* is a *list*, *textblock* is an *object*
and *text* and *font* are *properties*.

Setup
-----

To setup dungdungdung, you have to create and map some objects. For the default
setup you can just use the ``defaultSetup`` utility function in some command::

    import org.swiftsuspenders.Injector;
    import dung.dung.dung.defaultSetup
    import dung.dung.dung.interfaces.INodeMap;
	
    class StartUpCommand extends Command
    {
        override public function execute():void
        {
            // pass defaultSetup an org.swiftsuspenders.Injector object,
            // cast if needed.
            var nodeMap:INodeMap = defaultSetup(this.injector as Injector);
            
            // You could do your node mapping here. (See 'Map xml nodes to view components and value objects')
            /* ... */
        }
    }

Or you can specify a different nodeName using the second parameter of
``defaultSetup``::
    
    // this will make ``dungdungdung`` treat nodes with the name *items* as *lists*.
    defaultSetup(this.injector as Injector, 'items');

Doing the above makes ``dungdungdung`` look for the ``<items/>`` node instead of the
``<children/>`` node for creating ``childList``'s::

    <root>
        <pages>
            <page>
                <name>defaultSetup</name>
                <title>defaultSetup can have an optional childlistNodeName parameter</title>
                <!-- items marks child objects need to be created, because -->
                <!-- we told dungdungdung that -->
                <items>
                    <textblock>
                        <text>
                            hi there I am a child.
                        </text>
                        <font>Arial</font>
                    </textblock>
                    <imageviewer>
                        <children>
                            <image>
                                <description>What a pretty image indeed</description>
                                <url><a href="prettyimage.jpg"/></url>
                            </image>
                            <image>
                                <description>What an ugly image indeed</description>
                                <url><a href="uglyimage.jpg"/></url>
                            </image>
                        </children>
                    </imageviewer>
                </items>
            </page>
            <!-- more pages go here -->
        </pages>
    </root>

You can look into the sourceCode of ``defaultSetup`` to see what exactly is
needed to start using ``dungdungdung``

    
Map xml nodes to view components and value objects
--------------------------------------------------

Now that you created the *NodeMap*, it is time to tell dungdungdung what you would
like to have created for each xml node. You have to map the *objects* in the xml::

    // somewhere where you've got a nodeMap reference
    nodeMap.mapPath('page', Page, PageVO);
    nodeMap.mapPath('textblock', TextBlock, TextBlockVO);
    nodeMap.mapPath('imageviewer', ImageViewer);
    nodeMap.mapPath('imageviewer.children.image', ImageViewerItem, ImageViewerItemVO);
    
    // You've got to do your view mapping yourself, because you 
    // probably want to map interfaces instead of concrete classes.
    // You don't have to map the value objects though ...
    injector.mapClass(Page, Page);
    injector.mapClass(TextBlock, TextBlock);
    injector.mapClass(ImageViewer, ImageViewer);
    injector.mapClass(ImageViewerItem, ImageViewerItem);
    
    // add mediator maps if you need them.
    ...
    
Now dungdungdung knows that when a <page/> node is encountered, it should create
a Page view component and a PageVO value object. All the *properties* inside the
<page/> node will be mapped for injection into the PageVO. PageVO will look like
this::

    package foo {
        public class PageVO {
            
            [Inject(name='name')]
            public var pageName:String;
            
            [Inject(name='title')]
            public var title:string;
        }
    }

An instance of PageVO will be created, and the values in the <title/> and <name/>
nodes will be injected.

The Page class should have at least the following code::

    package foo {
        public class Page extends Sprite
        {
            [Inject]
            public var dataProvider:PageVO;
            
            [Inject]
            public var childList:IChildList;
            
        }
    }

The Page that will be created will receive the PageVO with the *properties* of the
<page/> *object* injected. Also it will receive an IChildList instance. The ChildList
is the factory in dungdungdung. It is used for all *lists* in the xml. The ChildList
has the following interface::

    package dung.dung.dung.interfaces
    {
        import flash.display.DisplayObjectContainer;

        public interface IChildList {

            function addChildrenTo(parent:DisplayObjectContainer):Array;
            function addChildrenOfTypeTo(type:Class, parent:DisplayObjectContainer):Array;
            function children():Array;
            function childrenOfType(type:Class):Array;
            function iteratorForType(type:Class):IChildListIterator;
        }

    }

The ChildList is **Lazy**, which means that it does absolutely nothing, only when
you access one of it's factory methods, it will create objects. The IChildList
instance inside Page can be used as follows::

    package foo {
        public class Page extends Sprite
        {
            [Inject]
            public var dataProvider:PageVO;
        
            [Inject]
            public var childList:IChildList;
        
            [PostConstruct]
            public function initialize():void
            {
                var children:Array = childList.addChildrenTo(this);
                // do some alignment on the children, you have them in an array.
            }
        }
    }

This will go the same same path as with Page, creating TextBlock instances and
ImageViewer instances with the proper value objects injected.

If you don't want to expand the entire tree and create all objects, you don't
have to! ``ChildList`` is **lazy** you can wait for an event or whatever and only
then start creating the objects. If you want the ``ChildList`` to be even more
lazy, like when you need only *some* of the objects in it and not *all*, you can
use *The Iterator*, ``childList.iteratorForType(SomeType)`` (See section
'The Iterator' below).

Note that ImageViewer does not have any *properties*, so it does not need a
value object, this is reflected in the mapping which was::
    
    nodeMap.mapPath('imageviewer', ImageViewer);

Bind *properties* directly to a view component
----------------------------------------------

If you want to, you can also bind the *properties* directly to the view component.
Just don't declare a value object when you map the path and move the properties
to the view component::

    package foo {
        public class Page extends Sprite
        {
            [Inject(name='name')]
            public var pageName:String;
        
            [Inject(name='title')]
            public var title:string;
    
            [Inject]
            public var childList:IChildList;
    
            [PostConstruct]
            public function initialize():void
            {
                var children:Array = childList.addChildrenTo(this);
                // do some alignment on the children, you have them in an array.
                // ...
                
                // when you are done with the childList, null it so the objects
                // can be garbage collected.
                childList = null;
            }
        }
    }

That will also work just fine. Ofcourse, you can also use the same trick to have
dungdungdung create only value object (trees) for you, and no viewcomponents at all.

Start up the factory
--------------------

Above is explained what happens when dungdungdung get's going. To start it up,
you have to load your xml and set up the root ChildList. dungdungdung does not
load xml for you, there are millions of things that load out there, so use one
of those. Setting up the root ChildList works as follows::
    
    // import childList factory function.
    import dung.dung.dung.createChildList;
	
    // lets say your xml loaded and inside a local variable name xml
    var xml:XML = // whatever
    
    // you must pass in an XMLList into a ChildList,
    // in this case select the <pages/> *list*
    
    var rootList:IChildList = createChildList(xml.pages, injector);
    
    rootList.addChildrenTo(contextView);

Ofcourse, you might not want to create all pages inside your application at once.
You could handle the creation of the pages yourself and give each page a rootList::

    // inside you Page mediator
    var pageList:IChildList = createChildList(pagexml, injector);
    (this.getViewComponent() as Page).childList = pageList;

Or you might want to use **The Iterator**.


The Iterator
------------

The iterator gives you lazy object creation. Not the entire list of objects is
created at once, only the objects you request. This means acces by index::

    // only create item at index 5
    var a:MyViewType = childList.iteratorForType(MyViewType)[5];

But also access by looping (iteration)::
    
    // only create first 8 items.
    // Note that the 6th item is allready created in the example above so it will return
    // the same object as is bound to variable 'a'
    var index:int = 0;
    for each(instance:MyViewType in childList.iteratorForType(MyViewType)) {
        if (index < 8) {
            this.addChild(instance);
            index++;
        } else {
            break;
        }
    }

lists are mixed
---------------

As you can see in the above XML, there are several types of *objects* inside the
*children* list of <page/>. You might want to create these objects separately and
do something different with each type. If you looked at the interface of IChildList,
you might have noticed that can be done::

    package foo {
        public class Page extends Sprite
        {
            [Inject]
            public var dataProvider:PageVO;
        
            [Inject]
            public var childList:IChildList;

            [PostConstruct]
            public function initialize():void
            {
                // only create the textblock instances, do the rest later
                var textBlocks:Array = childList.addChildrenOfTypeTo(TextBlock, this);
            }
        }
    }

You can also only create the objects but not add them to any DisplayObjectContainer,
just look at the IChildList methods.

Special cases
-------------

In any real world application there are special cases. For example it could be
that you've got xml where the node <item/> means something different when it is
a child of <inventory/> then when it is a child of <newslist/>. Fortunately the
NodeMap maps **paths** not just node names. so you can map the 2 different types
of item as follows::

    nodeMap.mapPath('inventory.children.item', InventoryItem, InventoryItemVO);
    nodeMap.mapPath('newslist.children.item', NewsItem, NewsItemVO);

Now it could be that there is an even more special case then that. It could be that
only for one Page the TextBlock should be some special class. You can not solve that
with NodeMap.

Because dungdungdung uses childInjectors you can override the map inside Page,
without any of the other pages suffering from it. The child injector is only a
cast away::

    package foo {
        public class Page extends Sprite
        {
            [Inject]
            public var dataProvider:PageVO;
            
            [Inject]
            public var childList:IChildList;
    
    
            [PostConstruct]
            public function initialize():void
            {
                if (page.pageName == 'veryspecial'){
                    // we haven't accessed childList yet, so the objects are not yet constructed.
                    var injector:Injector = (childList as ChildList).injector;
                    // use a special textblock for this page only
                    injector.mapClass(TextBlock, SpecialTextBlock);
                }
                childList.addChildrenOfTypeTo(TextBlock, this);
            }
        }
    }

This will not change any of the other pages, because each ChildList uses it's own
child injector. You can override view mappings, but not value object mappings.
This is because the value object is created using injector.instantiate and the view
component using injector.getInstance. It would also be very silly to override the
value object because it's just a bunch of properties ...

Properties are injected either as String or XML
-----------------------------------------------

Notice that <image/> in the above xml has 2 *properties*; <description/> and <url/>.
<description/> is a regular string, but for <url/> i chose to use an anchor, because
when google might index the xml, it will follow the link. If the content of a *property*
is not just a string, ChildList will map the value as XML, so the ImageViewerItemVO
would look like this::

    package foo {
        public class ImageViewerItemVO {
            
            private var _url:String;
            
            [Inject(name='description')]
            public var description;
            
            // url is injected as XML, not String
            [Inject(name='url')]
            public function set urlSink(value:XML):void
            {
                // so some more parsing here and bind to _url
                _url = value.a.@href;
            }
            
            public function get url():String
            {
                return _url;
            }
        }
    }

Setter injection is used to parse the anchor inside <url/> and the parsed url
can be collected through the url getter. You can have all kinds of complex *properties*
this way.

Garbage collection
------------------

The ChildList keeps a reference to the objects inside it. When you are done with
the ChildList, make sure you null it, so it can be collected by the garbage
collector. The view components the ChildList created can then also be cleaned up
when nolonger nescessary.

It is also possible to clear the reference the childlist holds using the iterator::

    var iter:IChildListIterator = objects.iteratorForType(ViewMock1);
    iter[0] = null;

Or even delete items from the childlist entirely::

    var iter:IChildListIterator = objects.iteratorForType(ViewMock1);
    delete iter[0];

How to build
------------

1. Make sure to have mxmlc and compc in your path.
2. cd to the robotlegs-dungdungdung directory
3. type *make*

Now you will have and swc and an swf in your *bin* directory as well as the asdocs
built into the docs directory.

License
=======

If not otherwise specified, files in this project fall under the following license::

    Dungdungdung, object factory and databinding.
    Copyright (C) 2010  Lars van de Kerkhof

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
