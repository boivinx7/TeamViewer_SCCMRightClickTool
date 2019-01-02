# TeamViewer SCCMRightClickTool
Information from how and where to Put Action Files in I found installing the Powershell Right Click tools and then deleting folders by folders. But Having Looked a bit more I might have found this http://eddiejackson.net/wp/?p=16094
Which would have saved me a lot of time.

![alt text](https://i.imgur.com/F6jSivh.png)

I suggest that you use the MSI to install this.
So The Files that Are called by the Extentions are going to
C:\Program Files\MB_tools\TeamViewer_SCCMRightClickTool

You Will need to Edit the TeamViewerRightClickToolZSettings.xml file
To insert you teamviewer TokenID, It needs to be a token that Can read devices only, So I did not make it to be encryptable.
It's plain text Sorry.
```
<Objs Version="1.1.0.1" xmlns="http://schemas.microsoft.com/powershell/2004/04">
  <Obj RefId="0">
    <TN RefId="0">
      <T>System.Management.Automation.PSCustomObject</T>
      <T>System.Object</T>
    </TN>
    <MS>
	<!-- TeamViewer App Token Needs to Be User Level -->
      <S N="UserToken">PutTockerHere</S>
	  <!-- TeamViewer Password if always the same can be userfull -->
	  <S N="TeamViewerPassword"></S>
    </MS>
  </Obj>
</Objs>
```
To know I to get a Teamviewer Token (you need a paid licences) and you Can Refer to Their API Documentation
https://www.teamviewer.com/en/for-developers/teamviewer-api/

The XML Actions Extentions will go to 
C:\Program Files (x86)\Microsoft Configuration Manager\AdminConsole\XmlStorage\Extensions\Actions\3fd01cd1-9e01-461e-92cd-94866b8d1f39
C:\Program Files (x86)\Microsoft Configuration Manager\AdminConsole\XmlStorage\Extensions\Actions\ed9dee86-eadd-4ac8-82a1-7234a4646e62

![alt text](https://i.imgur.com/x9FhnmK.png)

Content of the XML File
```
<ActionDescription Class="Group" DisplayName="Teamviewer RCT" MnemonicDisplayName="Teamviewer RCT" Description="Created by MB_Toolz" SqmDataPoint="53">
<ShowOn>
	<string>ContextMenu</string>
</ShowOn>
<ImagesDescription>
	<ResourceAssembly>
		<Assembly>C:\Program Files\MB_tools\TeamViewer_SCCMRightClickTool\Icons.dll</Assembly>
		<Type>Icons.Properties.Resources.resources</Type>
	</ResourceAssembly>
	<ImageResourceName>teamviewer</ImageResourceName>
</ImagesDescription>
<ActionGroups>

<ActionDescription Class="Executable" DisplayName="Remote Control" MnemonicDisplayName="Remote Control" Description="Created by MB_Toolz">
		<ShowOn>
			<string>ContextMenu</string>
		</ShowOn>
<ImagesDescription>
	<ResourceAssembly>
		<Assembly>C:\Program Files\MB_tools\TeamViewer_SCCMRightClickTool\Icons.dll</Assembly>
		<Type>Icons.Properties.Resources.resources</Type>
	</ResourceAssembly>
	<ImageResourceName>remotecontrol</ImageResourceName>
</ImagesDescription>
		<Executable>
			<FilePath>"C:\Program Files\MB_tools\TeamViewer_SCCMRightClickTool\TeamViewerRightClickTool.exe"</FilePath>
			    <Parameters>"##SUB:ResourceID##" ##SUB:__Server## ##SUB:__Namespace## Remote"</Parameters>
		</Executable>
</ActionDescription>
	
<ActionDescription Class="Executable" DisplayName="File Transfer " MnemonicDisplayName="File Transfer" Description="v" SqmDataPoint="53">
	<ShowOn>
		<string>ContextMenu</string>
	</ShowOn>
<ImagesDescription>
	<ResourceAssembly>
		<Assembly>C:\Program Files\MB_tools\TeamViewer_SCCMRightClickTool\Icons.dll</Assembly>
		<Type>Icons.Properties.Resources.resources</Type>
	</ResourceAssembly>
	<ImageResourceName>filetransfer</ImageResourceName>
</ImagesDescription>
	<Executable>
		<FilePath>"C:\Program Files\MB_tools\TeamViewer_SCCMRightClickTool\TeamViewerRightClickTool.exe"</FilePath>
		<Parameters>"##SUB:ResourceID##" ##SUB:__Server## ##SUB:__Namespace## File"</Parameters>
	</Executable>
</ActionDescription>

<ActionDescription Class="Executable" DisplayName="VPN" MnemonicDisplayName="VPN" Description="Created by MB_Toolz">
		<ShowOn>
			<string>ContextMenu</string>
		</ShowOn>
<ImagesDescription>
	<ResourceAssembly>
		<Assembly>C:\Program Files\MB_tools\TeamViewer_SCCMRightClickTool\Icons.dll</Assembly>
		<Type>Icons.Properties.Resources.resources</Type>
	</ResourceAssembly>
	<ImageResourceName>vpn</ImageResourceName>
</ImagesDescription>
		<Executable>
			<FilePath>"C:\Program Files\MB_tools\TeamViewer_SCCMRightClickTool\TeamViewerRightClickTool.exe"</FilePath>
			    <Parameters>"##SUB:ResourceID##" ##SUB:__Server## ##SUB:__Namespace## VPN"</Parameters>
		</Executable>
</ActionDescription>
</ActionGroups>
</ActionDescription>

```
Also, Disclaimer,
If i'm using any Icon that I should not use, please tell me,
I can remove it or add a reference if you want. This is 100% a free project that I did mainly for myself and tought that I would Share.
Thanks
