<map version="freeplane 1.6.0">
<!--To view this file, download free mind mapping software Freeplane from http://freeplane.sourceforge.net -->
<node TEXT="Spago" FOLDED="false" ID="ID_1908593445" CREATED="1553220819735" MODIFIED="1553220826907" STYLE="oval">
<font SIZE="18"/>
<hook NAME="MapStyle" zoom="0.751">
    <properties edgeColorConfiguration="#808080ff,#ff0000ff,#0000ffff,#00ff00ff,#ff00ffff,#00ffffff,#7c0000ff,#00007cff,#007c00ff,#7c007cff,#007c7cff,#7c7c00ff" fit_to_viewport="false"/>

<map_styles>
<stylenode LOCALIZED_TEXT="styles.root_node" STYLE="oval" UNIFORM_SHAPE="true" VGAP_QUANTITY="24.0 pt">
<font SIZE="24"/>
<stylenode LOCALIZED_TEXT="styles.predefined" POSITION="right" STYLE="bubble">
<stylenode LOCALIZED_TEXT="default" ICON_SIZE="12.0 pt" COLOR="#000000" STYLE="fork">
<font NAME="SansSerif" SIZE="10" BOLD="false" ITALIC="false"/>
</stylenode>
<stylenode LOCALIZED_TEXT="defaultstyle.details"/>
<stylenode LOCALIZED_TEXT="defaultstyle.attributes">
<font SIZE="9"/>
</stylenode>
<stylenode LOCALIZED_TEXT="defaultstyle.note" COLOR="#000000" BACKGROUND_COLOR="#ffffff" TEXT_ALIGN="LEFT"/>
<stylenode LOCALIZED_TEXT="defaultstyle.floating">
<edge STYLE="hide_edge"/>
<cloud COLOR="#f0f0f0" SHAPE="ROUND_RECT"/>
</stylenode>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.user-defined" POSITION="right" STYLE="bubble">
<stylenode LOCALIZED_TEXT="styles.topic" COLOR="#18898b" STYLE="fork">
<font NAME="Liberation Sans" SIZE="10" BOLD="true"/>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.subtopic" COLOR="#cc3300" STYLE="fork">
<font NAME="Liberation Sans" SIZE="10" BOLD="true"/>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.subsubtopic" COLOR="#669900">
<font NAME="Liberation Sans" SIZE="10" BOLD="true"/>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.important">
<icon BUILTIN="yes"/>
</stylenode>
</stylenode>
<stylenode LOCALIZED_TEXT="styles.AutomaticLayout" POSITION="right" STYLE="bubble">
<stylenode LOCALIZED_TEXT="AutomaticLayout.level.root" COLOR="#000000" STYLE="oval" SHAPE_HORIZONTAL_MARGIN="10.0 pt" SHAPE_VERTICAL_MARGIN="10.0 pt">
<font SIZE="18"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,1" COLOR="#0033ff">
<font SIZE="16"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,2" COLOR="#00b439">
<font SIZE="14"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,3" COLOR="#990000">
<font SIZE="12"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,4" COLOR="#111111">
<font SIZE="10"/>
</stylenode>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,5"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,6"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,7"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,8"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,9"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,10"/>
<stylenode LOCALIZED_TEXT="AutomaticLayout.level,11"/>
</stylenode>
</stylenode>
</map_styles>
</hook>
<hook NAME="AutomaticEdgeColor" COUNTER="1" RULE="ON_BRANCH_CREATION"/>
<richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Dependency Manager
    </p>
    <p>
      &amp; Build Tool
    </p>
  </body>
</html>

</richcontent>
<node TEXT="version 0.7.2.0" POSITION="right" ID="ID_1828135657" CREATED="1551923344241" MODIFIED="1553220842081">
<edge COLOR="#ff0000"/>
<node TEXT="(other commands)" ID="ID_1325665535" CREATED="1552093096477" MODIFIED="1552093099583">
<node TEXT="sources" ID="ID_80023375" CREATED="1551923369609" MODIFIED="1551923611658"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Lists all the source paths (globs) for the dependencies of the project
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="version" ID="ID_1356587097" CREATED="1551923395002" MODIFIED="1551924228905"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Shows spago's version
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="(commands related to package set configuration)" ID="ID_1837762545" CREATED="1552093036357" MODIFIED="1552093047232">
<node TEXT="verify" ID="ID_1730545713" CREATED="1551923372697" MODIFIED="1551923749219"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Verify that a single package is consistent with the Package Set
    </p>
  </body>
</html>
</richcontent>
<node TEXT="[ -j | --jobs ]" ID="ID_211450849" CREATED="1551923492946" MODIFIED="1551923595223"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Limit the amount of jobs that can run concurrently
    </p>
  </body>
</html>
</richcontent>
<node TEXT="PACKAGE" ID="ID_582433424" CREATED="1551923551151" MODIFIED="1551923789673"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      name of a single package to verify
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
</node>
<node TEXT="verify-set" ID="ID_444156177" CREATED="1551923374153" MODIFIED="1551923823575"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Verify that the whole Package Set builds correctly
    </p>
  </body>
</html>
</richcontent>
<node TEXT="[ -j | --jobs ]" ID="ID_213502194" CREATED="1551923492946" MODIFIED="1551923595223"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Limit the amount of jobs that can run concurrently
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="package-set-upgrade" ID="ID_853983909" CREATED="1551923380937" MODIFIED="1552092372600"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Upgrades the local copy of the official package set to its latest version.
    </p>
    <p>
      
    </p>
    <p>
      This will modify the 'upstream' record in 'packages.dhall' file to the latest package-sets release
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="freeze" ID="ID_1936964086" CREATED="1551923384593" MODIFIED="1551924134460"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Add hashes to the package-set, so it will be cached
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="list-packages" ID="ID_1432399810" CREATED="1551923370817" MODIFIED="1552092619411"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      List that packages you can install
    </p>
    <p>
      (i.e. packages available in your packages.dhall file)
    </p>
  </body>
</html>
</richcontent>
<node TEXT="[ -f | --filter ]" ID="ID_937259372" CREATED="1551923629012" MODIFIED="1551923669418">
<node TEXT="FILTER" ID="ID_1688963264" CREATED="1551923670373" MODIFIED="1551923695263"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      &quot;direct&quot; - only show direct dependencies
    </p>
    <p>
      &quot;transitive&quot; - show direct and transitive dependencies
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
</node>
<node TEXT="install" ID="ID_996748792" CREATED="1551923368362" MODIFIED="1551923369429">
<node TEXT="[ -j | --jobs ]" ID="ID_377523207" CREATED="1551923492946" MODIFIED="1551923595223"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Limit the amount of jobs that can run concurrently
    </p>
  </body>
</html>
</richcontent>
<node TEXT="PACKAGE" ID="ID_255025430" CREATED="1551923551151" MODIFIED="1551923562409"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      name of the package to add as a dependency
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
</node>
</node>
<node TEXT="(commands related to project)" ID="ID_696549414" CREATED="1552093055189" MODIFIED="1553221187815">
<node TEXT="init" ID="ID_1983711222" CREATED="1551923356426" MODIFIED="1551923451825"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Initialize a new sample project
    </p>
    <p>
      OR
    </p>
    <p>
      migrate from a psc-package project to a spago project
    </p>
  </body>
</html>
</richcontent>
<node TEXT="[-f | --force ]" ID="ID_280121495" CREATED="1551923452915" MODIFIED="1551923525776"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Overwrite any project found in current directory
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="repl" ID="ID_1424544775" CREATED="1551923376633" MODIFIED="1551923927203"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Start a REPL
    </p>
  </body>
</html>
</richcontent>
<node TEXT="" ID="ID_1813948645" CREATED="1551923937034" MODIFIED="1551923937035">
<hook NAME="FirstGroupNode"/>
</node>
<node TEXT="[ -p | --path]" ID="ID_1150062736" CREATED="1551923849311" MODIFIED="1551923856188">
<node TEXT="PATH" ID="ID_1869690305" CREATED="1551923874911" MODIFIED="1551923883158"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Source path to include
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="" ID="ID_861745913" CREATED="1551923937032" MODIFIED="1551923937034">
<hook NAME="SummaryNode"/>
<hook NAME="AlwaysUnfoldedNode"/>
<node TEXT="--" ID="ID_1759521351" CREATED="1551923986403" MODIFIED="1551923988108">
<node TEXT="[any &apos;purs compile&apos; options]" ID="ID_613849544" CREATED="1551923996105" MODIFIED="1553221138663"/>
</node>
</node>
</node>
<node TEXT="docs" ID="ID_1505248730" CREATED="1553221213694" MODIFIED="1553221223291"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Generate docs for the project and its dependencies
    </p>
  </body>
</html>

</richcontent>
<node TEXT="[ -p | --path]" ID="ID_256941347" CREATED="1551923849311" MODIFIED="1551923856188">
<node TEXT="PATH" ID="ID_1330873676" CREATED="1551923874911" MODIFIED="1553221250973"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Source path to include
    </p>
  </body>
</html>

</richcontent>
</node>
</node>
</node>
<node TEXT="build" ID="ID_1727984941" CREATED="1551923375481" MODIFIED="1551923922414"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Install the dependencies and compile the current package
    </p>
  </body>
</html>
</richcontent>
<node TEXT="" ID="ID_1401758173" CREATED="1551923886184" MODIFIED="1551923886184">
<hook NAME="FirstGroupNode"/>
</node>
<node TEXT="[ -j | --jobs ]" ID="ID_803855977" CREATED="1551923492946" MODIFIED="1551923595223"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Limit the amount of jobs that can run concurrently
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -p | --path]" ID="ID_967318491" CREATED="1551923849311" MODIFIED="1553221071487">
<node TEXT="PATH" ID="ID_1868546228" CREATED="1551923874911" MODIFIED="1551923883158"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Source path to include
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="[ -w | --watch]" ID="ID_482801698" CREATED="1553221031133" MODIFIED="1553221045369"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Watch for changes in local files and automatically rebuild
    </p>
  </body>
</html>

</richcontent>
</node>
<node TEXT="" ID="ID_257320090" CREATED="1551923886183" MODIFIED="1551923886184">
<hook NAME="SummaryNode"/>
<hook NAME="AlwaysUnfoldedNode"/>
<node TEXT="--" ID="ID_1215626806" CREATED="1551923886185" MODIFIED="1551923890524">
<node TEXT="[any &apos;purs compile&apos; options]" ID="ID_105848326" CREATED="1551923890896" MODIFIED="1553221155829"/>
</node>
</node>
</node>
<node TEXT="test" ID="ID_420681374" CREATED="1551923377441" MODIFIED="1551924051141"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Test the project with some module
    </p>
  </body>
</html>
</richcontent>
<node TEXT="" ID="ID_865276853" CREATED="1551923986402" MODIFIED="1551923986403">
<hook NAME="FirstGroupNode"/>
</node>
<node TEXT="[ -m | --main ]" ID="ID_1184648821" CREATED="1551923958208" MODIFIED="1551923963892">
<node TEXT="MAIN" ID="ID_1241535036" CREATED="1551923964176" MODIFIED="1551924060408"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      the main module to bundle
    </p>
    <p>
      
    </p>
    <p>
      Default value:
    </p>
    <p>
      'Test.Main'
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="[ -j | --jobs ]" ID="ID_1464785941" CREATED="1551923492946" MODIFIED="1551923595223"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Limit the amount of jobs that can run concurrently
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -p | --path]" ID="ID_1268693328" CREATED="1551923849311" MODIFIED="1551923856188">
<node TEXT="PATH" ID="ID_1480896381" CREATED="1551923874911" MODIFIED="1551923883158"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Source path to include
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="[ -w | --watch]" ID="ID_160146076" CREATED="1553221031133" MODIFIED="1553221045369"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Watch for changes in local files and automatically rebuild
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="" ID="ID_1545637832" CREATED="1551923986401" MODIFIED="1551923986402">
<hook NAME="SummaryNode"/>
<hook NAME="AlwaysUnfoldedNode"/>
<node TEXT="--" ID="ID_519096311" CREATED="1551923986403" MODIFIED="1551923988108">
<node TEXT="[any &apos;purs compile&apos; options]" ID="ID_776246390" CREATED="1551923996105" MODIFIED="1553221138663"/>
</node>
</node>
</node>
<node TEXT="run" ID="ID_17009802" CREATED="1551923377441" MODIFIED="1553221114130"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Runs the project with some module
    </p>
  </body>
</html>

</richcontent>
<node TEXT="" ID="ID_1271081994" CREATED="1551923986402" MODIFIED="1551923986403">
<hook NAME="FirstGroupNode"/>
</node>
<node TEXT="[ -m | --main ]" ID="ID_1483565845" CREATED="1551923958208" MODIFIED="1551923963892">
<node TEXT="MAIN" ID="ID_814287722" CREATED="1551923964176" MODIFIED="1553221122243"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      the main module to bundle
    </p>
    <p>
      
    </p>
    <p>
      Default value:
    </p>
    <p>
      'Main'
    </p>
  </body>
</html>

</richcontent>
</node>
</node>
<node TEXT="[ -j | --jobs ]" ID="ID_814810531" CREATED="1551923492946" MODIFIED="1551923595223"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Limit the amount of jobs that can run concurrently
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -p | --path]" ID="ID_1352295868" CREATED="1551923849311" MODIFIED="1551923856188">
<node TEXT="PATH" ID="ID_1822026015" CREATED="1551923874911" MODIFIED="1551923883158"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Source path to include
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="[ -w | --watch]" ID="ID_259856045" CREATED="1553221031133" MODIFIED="1553221045369"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Watch for changes in local files and automatically rebuild
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="" ID="ID_1125249614" CREATED="1551923986401" MODIFIED="1551923986402">
<hook NAME="SummaryNode"/>
<hook NAME="AlwaysUnfoldedNode"/>
<node TEXT="--" ID="ID_1184151191" CREATED="1551923986403" MODIFIED="1551923988108">
<node TEXT="[any &apos;purs compile&apos; options]" ID="ID_1978273904" CREATED="1551923996105" MODIFIED="1553221144050"/>
</node>
</node>
</node>
<node TEXT="" ID="ID_744024251" CREATED="1553221400501" MODIFIED="1553221400502">
<hook NAME="FirstGroupNode"/>
</node>
<node TEXT="bundle" ID="ID_708362753" CREATED="1551923378169" MODIFIED="1553221542638"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Bundle the project's top-level module
    </p>
    <p>
      into a single executable file
    </p>
  </body>
</html>

</richcontent>
<node TEXT="[ -m | --main ]" ID="ID_1891227632" CREATED="1551923958208" MODIFIED="1551923963892">
<node TEXT="MAIN" ID="ID_1621837890" CREATED="1551923964176" MODIFIED="1551923969878"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      the main module to bundle
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="[ -t | --to ]" ID="ID_1499028952" CREATED="1551924016257" MODIFIED="1551924024566">
<node TEXT="TO" ID="ID_1560703331" CREATED="1551924025017" MODIFIED="1551924030373"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      The target file path
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="[ -s | --no-build ]" ID="ID_1708256647" CREATED="1553221309505" MODIFIED="1553221322616"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Skips the build step that otherwise runs
    </p>
  </body>
</html>

</richcontent>
</node>
<node TEXT="[ -j | --jobs ]" ID="ID_721341527" CREATED="1551923492946" MODIFIED="1551923595223"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Limit the amount of jobs that can run concurrently
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -p | --path]" ID="ID_234711397" CREATED="1551923849311" MODIFIED="1551923856188">
<node TEXT="PATH" ID="ID_800041234" CREATED="1551923874911" MODIFIED="1551923883158"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Source path to include
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="[ -w | --watch]" ID="ID_903868861" CREATED="1553221031133" MODIFIED="1553221045369"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Watch for changes in local files and automatically rebuild
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="" ID="ID_1968736059" CREATED="1553221400499" MODIFIED="1553221400501">
<hook NAME="SummaryNode"/>
<hook NAME="AlwaysUnfoldedNode"/>
<node TEXT="--" ID="ID_1182015602" CREATED="1551923986403" MODIFIED="1551923988108">
<node TEXT="[any &apos;purs compile&apos; options]" ID="ID_855535321" CREATED="1551923996105" MODIFIED="1553221144050"/>
</node>
</node>
<node TEXT="" ID="ID_1843038471" CREATED="1553221438415" MODIFIED="1553221438415">
<hook NAME="FirstGroupNode"/>
</node>
<node TEXT="make-module" ID="ID_1283635223" CREATED="1551923379385" MODIFIED="1551924087079"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Bundle a module into a CommonJS module
    </p>
  </body>
</html>
</richcontent>
<node TEXT="[ -m | --main ]" ID="ID_1440729834" CREATED="1551923958208" MODIFIED="1551923963892">
<node TEXT="MAIN" ID="ID_1128584868" CREATED="1551923964176" MODIFIED="1551923969878"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      the main module to bundle
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="[ -t | --to ]" ID="ID_1571824870" CREATED="1551924016257" MODIFIED="1551924024566">
<node TEXT="TO" ID="ID_1174561061" CREATED="1551924025017" MODIFIED="1551924030373"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      The target file path
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="[ -s | --no-build ]" ID="ID_1300659981" CREATED="1553221309505" MODIFIED="1553221322616"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Skips the build step that otherwise runs
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -j | --jobs ]" ID="ID_1239947666" CREATED="1551923492946" MODIFIED="1551923595223"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Limit the amount of jobs that can run concurrently
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -p | --path]" ID="ID_253448293" CREATED="1551923849311" MODIFIED="1551923856188">
<node TEXT="PATH" ID="ID_310777196" CREATED="1551923874911" MODIFIED="1551923883158"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Source path to include
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="[ -w | --watch]" ID="ID_909365036" CREATED="1553221031133" MODIFIED="1553221045369"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Watch for changes in local files and automatically rebuild
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="" ID="ID_616085202" CREATED="1553221438414" MODIFIED="1553221438415">
<hook NAME="SummaryNode"/>
<hook NAME="AlwaysUnfoldedNode"/>
<node TEXT="--" ID="ID_817014942" CREATED="1551923986403" MODIFIED="1551923988108">
<node TEXT="[any &apos;purs compile&apos; options]" ID="ID_1719987070" CREATED="1551923996105" MODIFIED="1553221144050"/>
</node>
</node>
</node>
<node TEXT="(commands for `psc-package` things&#xa;if one does not want to use Dhall)" ID="ID_1513908151" CREATED="1552092321492" MODIFIED="1552093129287">
<node TEXT="psc-package-local-setup" ID="ID_74286227" CREATED="1551923385858" MODIFIED="1551924158465"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Set up a local package set by creating a new 'packages.dhall' file
    </p>
  </body>
</html>
</richcontent>
<node TEXT="[-f | --force ]" ID="ID_462213785" CREATED="1551923452915" MODIFIED="1551923525776"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Overwrite any project found in current directory
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="psc-package-insdhall" ID="ID_114794008" CREATED="1551923389073" MODIFIED="1551924197486"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Installs the local package set from the 'packages.dhall' file
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="psc-package-clean" ID="ID_1966138498" CREATED="1551923392762" MODIFIED="1551924215009"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Clean cached packages by deleting the &quot;.psc-package&quot; folder
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
</node>
</node>
</map>
