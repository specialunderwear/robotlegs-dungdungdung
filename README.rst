dungdungdung object factory and databinding.
============================================

get started
-----------

Create an xml with a structure similar to this one. This is the type of xml that
is produced by django-easymode.

.. code-block:: xml

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
                            metus sed congue gravida, arcu dui ornare urna, ut 
                            imperdiet enim odio dignissim ipsum. Nulla facilisi. Cras
                            magna ante, bibendum sit amet, porta vitae, laoreet ut,
                            justo. Nam tortor sapien, pulvinar nec, malesuada in,
                            ultrices in, tortor. Cras ultricies placerat eros.
                            Quisque odio eros, feugiat non, iaculis nec, lobortis
                            sed, arcu. Pellentesque sit amet sem et purus pretium
                            consectetuer.
                        </text>
                        <font>Arial</font>
                    </textblock>
                    <imageviewer>
                        <title>See my pretty pictures please</title>
                        <children>
                            <image>
                                <description>What a pretty image indeed</description>
                                <url>prettyimage.jpg</url>
                            </image>
                            <image>
                                <description>What an ugly image indeed</description>
                                <url>uglyimage.jpg</url>
                            </image>
                        </children>
                    </imageviewer>
                </children>
            </page>
        </pages>
    </root>

dungdungdung is a work in progress.

It will be the actionscript bindings for the django-easymode.


 