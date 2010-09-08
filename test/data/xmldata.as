package data
{	
	public var xmldata:XML = <root>
		<assets>
			<menu>
				<label>Hi</label>
				<children>
					<menuitem><a href="#/something">something</a></menuitem>
					<menuitem><a href="#/somethingelse">somethingelse</a></menuitem>
				</children>
			</menu>
		</assets>
		<pages>
			<page>
				<title>I am a page</title>
				<slug>something</slug>
				<menuitem>silly</menuitem>
			</page>
			<page>
				<title>I am another page</title>
				<slug>somethingelse</slug>
				<menuitem>weird</menuitem>
			</page>
		</pages>
	</root>;
}

