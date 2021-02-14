<map version="freeplane 1.7.0">
<!--To view this file, download free mind mapping software Freeplane from http://freeplane.sourceforge.net -->
<node TEXT="Spago" FOLDED="false" ID="ID_1908593445" CREATED="1553220819735" MODIFIED="1553220826907" STYLE="oval">
<font SIZE="18"/>
<hook NAME="MapStyle">
    <properties fit_to_viewport="false" edgeColorConfiguration="#808080ff,#ff0000ff,#0000ffff,#00ff00ff,#ff00ffff,#00ffffff,#7c0000ff,#00007cff,#007c00ff,#7c007cff,#007c7cff,#7c7c00ff"/>

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
<hook NAME="AutomaticEdgeColor" COUNTER="11" RULE="ON_BRANCH_CREATION"/>
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
<node TEXT="Older versions" FOLDED="true" POSITION="right" ID="ID_1265616342" CREATED="1582232227954" MODIFIED="1582232234274">
<edge COLOR="#7c7c00"/>
<node TEXT="version 0.7.2.0" FOLDED="true" ID="ID_1828135657" CREATED="1551923344241" MODIFIED="1582232227966">
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
<node TEXT="" ID="ID_152109807" CREATED="1558495435892" MODIFIED="1582232227968">
<hook NAME="FirstGroupNode"/>
</node>
<node TEXT="version 0.8.0.0" ID="ID_988920604" CREATED="1551923344241" MODIFIED="1582232227970"/>
<node TEXT="" ID="ID_1560293575" CREATED="1558495435886" MODIFIED="1582232227977">
<hook NAME="SummaryNode"/>
<hook NAME="AlwaysUnfoldedNode"/>
<node TEXT="" ID="ID_317323365" CREATED="1558495479891" MODIFIED="1558495479893">
<hook NAME="FirstGroupNode"/>
</node>
<node TEXT="Global options" FOLDED="true" ID="ID_375309264" CREATED="1558495435895" MODIFIED="1558495439967">
<node TEXT="--help" ID="ID_1226380692" CREATED="1558495443616" MODIFIED="1558495787155"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Show the help text
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="--verbose" ID="ID_945931432" CREATED="1558495447399" MODIFIED="1558495801569"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Enable additional debug logging (e.g. print the `purs` commands)
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="" ID="ID_1221358872" CREATED="1558495479887" MODIFIED="1558495479890">
<hook NAME="SummaryNode"/>
<hook NAME="AlwaysUnfoldedNode"/>
<node TEXT="commands" FOLDED="true" ID="ID_1806106473" CREATED="1558495479894" MODIFIED="1558495484890">
<node TEXT="[Package set commands]" ID="ID_215861180" CREATED="1552093036357" MODIFIED="1558495605739">
<node TEXT="install" ID="ID_1921605437" CREATED="1551923368362" MODIFIED="1558495559218"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Install (download) all dependencies listed in `spago.dhall` file
    </p>
  </body>
</html>
</richcontent>
<node TEXT="[ -j | --jobs ]" ID="ID_1710130913" CREATED="1551923492946" MODIFIED="1551923595223"><richcontent TYPE="DETAILS">

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
<node TEXT="PACKAGE" ID="ID_158082867" CREATED="1551923551151" MODIFIED="1551923562409"><richcontent TYPE="DETAILS">

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
<node TEXT="sources" ID="ID_117991303" CREATED="1551923369609" MODIFIED="1551923611658"><richcontent TYPE="DETAILS">

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
<node TEXT="list-packages" ID="ID_1135528499" CREATED="1551923370817" MODIFIED="1552092619411"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -f | --filter ]" ID="ID_1885989815" CREATED="1551923629012" MODIFIED="1551923669418">
<node TEXT="FILTER" ID="ID_521727362" CREATED="1551923670373" MODIFIED="1551923695263"><richcontent TYPE="DETAILS">

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
<node TEXT="verify" ID="ID_1390431132" CREATED="1551923372697" MODIFIED="1551923749219"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -j | --jobs ]" ID="ID_549102663" CREATED="1551923492946" MODIFIED="1551923595223"><richcontent TYPE="DETAILS">

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
<node TEXT="PACKAGE" ID="ID_919346162" CREATED="1551923551151" MODIFIED="1551923789673"><richcontent TYPE="DETAILS">

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
<node TEXT="verify-set" ID="ID_1142498855" CREATED="1551923374153" MODIFIED="1551923823575"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -j | --jobs ]" ID="ID_1567975660" CREATED="1551923492946" MODIFIED="1551923595223"><richcontent TYPE="DETAILS">

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
<node TEXT="package-set-upgrade" ID="ID_824057335" CREATED="1551923380937" MODIFIED="1552092372600"><richcontent TYPE="DETAILS">

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
<node TEXT="freeze" ID="ID_385437270" CREATED="1551923384593" MODIFIED="1551924134460"><richcontent TYPE="DETAILS">

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
</node>
<node TEXT="[Project commands]" ID="ID_182753037" CREATED="1552093055189" MODIFIED="1558495617412">
<node TEXT="init" ID="ID_512036244" CREATED="1551923356426" MODIFIED="1551923451825"><richcontent TYPE="DETAILS">

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
<node TEXT="[-f | --force ]" ID="ID_1036386758" CREATED="1551923452915" MODIFIED="1551923525776"><richcontent TYPE="DETAILS">

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
<node TEXT="repl" ID="ID_440575293" CREATED="1551923376633" MODIFIED="1551923927203"><richcontent TYPE="DETAILS">

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
<node TEXT="" ID="ID_1944888104" CREATED="1551923937034" MODIFIED="1551923937035">
<hook NAME="FirstGroupNode"/>
</node>
<node TEXT="[ -p | --path]" ID="ID_1786678892" CREATED="1551923849311" MODIFIED="1551923856188">
<node TEXT="PATH" ID="ID_1242374689" CREATED="1551923874911" MODIFIED="1551923883158"><richcontent TYPE="DETAILS">

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
<node TEXT="" ID="ID_1156472199" CREATED="1551923937032" MODIFIED="1551923937034">
<hook NAME="SummaryNode"/>
<hook NAME="AlwaysUnfoldedNode"/>
<node TEXT="--" ID="ID_605892718" CREATED="1551923986403" MODIFIED="1551923988108">
<node TEXT="[any &apos;purs compile&apos; options]" ID="ID_1045825595" CREATED="1551923996105" MODIFIED="1553221138663"/>
</node>
</node>
</node>
<node TEXT="docs" ID="ID_65908038" CREATED="1553221213694" MODIFIED="1553221223291"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -p | --path]" ID="ID_1969526769" CREATED="1551923849311" MODIFIED="1551923856188">
<node TEXT="PATH" ID="ID_1777044622" CREATED="1551923874911" MODIFIED="1553221250973"><richcontent TYPE="DETAILS">

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
<node TEXT="build" ID="ID_923791181" CREATED="1551923375481" MODIFIED="1551923922414"><richcontent TYPE="DETAILS">

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
<node TEXT="" ID="ID_1686891190" CREATED="1551923886184" MODIFIED="1551923886184">
<hook NAME="FirstGroupNode"/>
</node>
<node TEXT="[ -j | --jobs ]" ID="ID_155689468" CREATED="1551923492946" MODIFIED="1551923595223"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -p | --path]" ID="ID_1131921978" CREATED="1551923849311" MODIFIED="1553221071487">
<node TEXT="PATH" ID="ID_1694946511" CREATED="1551923874911" MODIFIED="1551923883158"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -w | --watch]" ID="ID_288442178" CREATED="1553221031133" MODIFIED="1553221045369"><richcontent TYPE="DETAILS">

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
<node TEXT="" ID="ID_690556277" CREATED="1551923886183" MODIFIED="1551923886184">
<hook NAME="SummaryNode"/>
<hook NAME="AlwaysUnfoldedNode"/>
<node TEXT="--" ID="ID_397070393" CREATED="1551923886185" MODIFIED="1551923890524">
<node TEXT="[any &apos;purs compile&apos; options]" ID="ID_1897097196" CREATED="1551923890896" MODIFIED="1553221155829"/>
</node>
</node>
</node>
<node TEXT="test" ID="ID_1764170298" CREATED="1551923377441" MODIFIED="1551924051141"><richcontent TYPE="DETAILS">

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
<node TEXT="" ID="ID_1932103401" CREATED="1551923986402" MODIFIED="1551923986403">
<hook NAME="FirstGroupNode"/>
</node>
<node TEXT="[ -m | --main ]" ID="ID_1789366784" CREATED="1551923958208" MODIFIED="1551923963892">
<node TEXT="MAIN" ID="ID_1875474551" CREATED="1551923964176" MODIFIED="1551924060408"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -j | --jobs ]" ID="ID_1379383557" CREATED="1551923492946" MODIFIED="1551923595223"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -p | --path]" ID="ID_1860718527" CREATED="1551923849311" MODIFIED="1551923856188">
<node TEXT="PATH" ID="ID_1072873739" CREATED="1551923874911" MODIFIED="1551923883158"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -w | --watch]" ID="ID_750637777" CREATED="1553221031133" MODIFIED="1553221045369"><richcontent TYPE="DETAILS">

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
<node TEXT="" ID="ID_788122623" CREATED="1551923986401" MODIFIED="1551923986402">
<hook NAME="SummaryNode"/>
<hook NAME="AlwaysUnfoldedNode"/>
<node TEXT="--" ID="ID_848676496" CREATED="1551923986403" MODIFIED="1551923988108">
<node TEXT="[any &apos;purs compile&apos; options]" ID="ID_776848116" CREATED="1551923996105" MODIFIED="1553221138663"/>
</node>
</node>
</node>
<node TEXT="run" ID="ID_1011802710" CREATED="1551923377441" MODIFIED="1553221114130"><richcontent TYPE="DETAILS">

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
<node TEXT="" ID="ID_1134986996" CREATED="1551923986402" MODIFIED="1551923986403">
<hook NAME="FirstGroupNode"/>
</node>
<node TEXT="[ -m | --main ]" ID="ID_1909753228" CREATED="1551923958208" MODIFIED="1551923963892">
<node TEXT="MAIN" ID="ID_870972533" CREATED="1551923964176" MODIFIED="1553221122243"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -j | --jobs ]" ID="ID_1792963822" CREATED="1551923492946" MODIFIED="1551923595223"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -p | --path]" ID="ID_747839" CREATED="1551923849311" MODIFIED="1551923856188">
<node TEXT="PATH" ID="ID_873128555" CREATED="1551923874911" MODIFIED="1551923883158"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -w | --watch]" ID="ID_520397477" CREATED="1553221031133" MODIFIED="1553221045369"><richcontent TYPE="DETAILS">

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
<node TEXT="" ID="ID_415776" CREATED="1551923986401" MODIFIED="1551923986402">
<hook NAME="SummaryNode"/>
<hook NAME="AlwaysUnfoldedNode"/>
<node TEXT="--" ID="ID_1494974990" CREATED="1551923986403" MODIFIED="1551923988108">
<node TEXT="[any &apos;purs compile&apos; options]" ID="ID_341954055" CREATED="1551923996105" MODIFIED="1553221144050"/>
</node>
</node>
</node>
<node TEXT="" ID="ID_1534356556" CREATED="1553221400501" MODIFIED="1553221400502">
<hook NAME="FirstGroupNode"/>
</node>
<node TEXT="bundle-app" ID="ID_732594914" CREATED="1551923378169" MODIFIED="1558495662075"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -m | --main ]" ID="ID_372502739" CREATED="1551923958208" MODIFIED="1551923963892">
<node TEXT="MAIN" ID="ID_1330277330" CREATED="1551923964176" MODIFIED="1558495716864"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Module with a `main :: Effect Unit` function,
    </p>
    <p>
      which is used as the application's entry point
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="[ -t | --to ]" ID="ID_1488923577" CREATED="1551924016257" MODIFIED="1551924024566">
<node TEXT="TO" ID="ID_928495177" CREATED="1551924025017" MODIFIED="1551924030373"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -s | --no-build ]" ID="ID_560324842" CREATED="1553221309505" MODIFIED="1553221322616"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -j | --jobs ]" ID="ID_1167754169" CREATED="1551923492946" MODIFIED="1551923595223"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -p | --path]" ID="ID_626388537" CREATED="1551923849311" MODIFIED="1551923856188">
<node TEXT="PATH" ID="ID_855764759" CREATED="1551923874911" MODIFIED="1551923883158"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -w | --watch]" ID="ID_1949793773" CREATED="1553221031133" MODIFIED="1553221045369"><richcontent TYPE="DETAILS">

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
<node TEXT="" ID="ID_34608566" CREATED="1553221400499" MODIFIED="1553221400501">
<hook NAME="SummaryNode"/>
<hook NAME="AlwaysUnfoldedNode"/>
<node TEXT="--" ID="ID_1731550374" CREATED="1551923986403" MODIFIED="1551923988108">
<node TEXT="[any &apos;purs compile&apos; options]" ID="ID_178827236" CREATED="1551923996105" MODIFIED="1553221144050"/>
</node>
</node>
<node TEXT="" ID="ID_871449495" CREATED="1553221438415" MODIFIED="1553221438415">
<hook NAME="FirstGroupNode"/>
</node>
<node TEXT="make-module" ID="ID_1549363466" CREATED="1551923379385" MODIFIED="1551924087079"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -m | --main ]" ID="ID_1501188886" CREATED="1551923958208" MODIFIED="1551923963892">
<node TEXT="MAIN" ID="ID_855475179" CREATED="1551923964176" MODIFIED="1558495761417"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Module which is used as the application's entry point
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="[ -t | --to ]" ID="ID_205334986" CREATED="1551924016257" MODIFIED="1551924024566">
<node TEXT="TO" ID="ID_1581028633" CREATED="1551924025017" MODIFIED="1551924030373"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -s | --no-build ]" ID="ID_404947381" CREATED="1553221309505" MODIFIED="1553221322616"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -j | --jobs ]" ID="ID_1270064238" CREATED="1551923492946" MODIFIED="1551923595223"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -p | --path]" ID="ID_1130712747" CREATED="1551923849311" MODIFIED="1551923856188">
<node TEXT="PATH" ID="ID_41450978" CREATED="1551923874911" MODIFIED="1551923883158"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -w | --watch]" ID="ID_354945197" CREATED="1553221031133" MODIFIED="1553221045369"><richcontent TYPE="DETAILS">

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
<node TEXT="" ID="ID_694438599" CREATED="1553221438414" MODIFIED="1553221438415">
<hook NAME="SummaryNode"/>
<hook NAME="AlwaysUnfoldedNode"/>
<node TEXT="--" ID="ID_1601691883" CREATED="1551923986403" MODIFIED="1551923988108">
<node TEXT="[any &apos;purs compile&apos; options]" ID="ID_1659907105" CREATED="1551923996105" MODIFIED="1553221144050"/>
</node>
</node>
</node>
<node TEXT="[Other commands]" ID="ID_600189079" CREATED="1552093096477" MODIFIED="1558495610520">
<node TEXT="version" ID="ID_1974460450" CREATED="1551923395002" MODIFIED="1551924228905"><richcontent TYPE="DETAILS">

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
<node TEXT="[Psc-Package compatibility commands]" ID="ID_1229363426" CREATED="1552092321492" MODIFIED="1558495625915">
<node TEXT="psc-package-local-setup" ID="ID_986187257" CREATED="1551923385858" MODIFIED="1551924158465"><richcontent TYPE="DETAILS">

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
<node TEXT="[-f | --force ]" ID="ID_1628218207" CREATED="1551923452915" MODIFIED="1551923525776"><richcontent TYPE="DETAILS">

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
<node TEXT="psc-package-insdhall" ID="ID_1046530387" CREATED="1551923389073" MODIFIED="1551924197486"><richcontent TYPE="DETAILS">

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
<node TEXT="psc-package-clean" ID="ID_91172140" CREATED="1551923392762" MODIFIED="1551924215009"><richcontent TYPE="DETAILS">

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
</node>
<node TEXT="" ID="ID_1370092711" CREATED="1564497083593" MODIFIED="1582232227978">
<hook NAME="FirstGroupNode"/>
</node>
<node TEXT="version 0.9.0.0" ID="ID_677236995" CREATED="1564497039392" MODIFIED="1582232227980"/>
<node TEXT="" ID="ID_1733887344" CREATED="1564497083587" MODIFIED="1582232227986">
<hook NAME="SummaryNode"/>
<hook NAME="AlwaysUnfoldedNode"/>
<node TEXT="Global Options" FOLDED="true" ID="ID_1185828842" CREATED="1574049355694" MODIFIED="1574049362903">
<node TEXT="" ID="ID_860119540" CREATED="1564497147002" MODIFIED="1564497147005">
<hook NAME="FirstGroupNode"/>
</node>
<node TEXT="[ -h | --help ]" ID="ID_1321923423" CREATED="1558495443616" MODIFIED="1564498063850"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Show the help text
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -v | --verbose ]" ID="ID_298488803" CREATED="1558495447399" MODIFIED="1564498081747"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Enable additional debug logging (e.g. print the `purs` commands)
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -P, --no-psa ]" ID="ID_322544814" CREATED="1564497099049" MODIFIED="1564498086121"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Don't build with 'psa', but use 'purs'
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -j, --jobs ]" ID="ID_982878235" CREATED="1564497118701" MODIFIED="1564498090908"><richcontent TYPE="DETAILS">

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
<node TEXT="" ID="ID_511228751" CREATED="1564497146997" MODIFIED="1564497147001">
<hook NAME="SummaryNode"/>
<hook NAME="AlwaysUnfoldedNode"/>
<node TEXT="commands" FOLDED="true" ID="ID_576566927" CREATED="1564497147007" MODIFIED="1564497180472">
<node TEXT="[Package set commands]" ID="ID_1843627948" CREATED="1552093036357" MODIFIED="1558495605739">
<node TEXT="install" ID="ID_648732855" CREATED="1551923368362" MODIFIED="1558495559218"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Install (download) all dependencies listed in `spago.dhall` file
    </p>
  </body>
</html>
</richcontent>
<node TEXT="[ -c | --global-cache ]" ID="ID_713069059" CREATED="1551923492946" MODIFIED="1564497356522"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Configure global caching behavior
    </p>
  </body>
</html>
</richcontent>
<node TEXT="GLOBAL-CACHE" ID="ID_1755990906" CREATED="1564497336734" MODIFIED="1564497351774"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      'skip' - don't use the global cache
    </p>
    <p>
      'update' - force an update to the global cache
    </p>
  </body>
</html>
</richcontent>
<node TEXT="PACKAGE" ID="ID_147488516" CREATED="1551923551151" MODIFIED="1551923562409"><richcontent TYPE="DETAILS">

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
<node TEXT="sources" ID="ID_873744068" CREATED="1551923369609" MODIFIED="1551923611658"><richcontent TYPE="DETAILS">

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
<node TEXT="list-packages" ID="ID_1423067061" CREATED="1551923370817" MODIFIED="1552092619411"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -f | --filter ]" ID="ID_908858526" CREATED="1551923629012" MODIFIED="1551923669418">
<node TEXT="FILTER" ID="ID_1624946812" CREATED="1551923670373" MODIFIED="1551923695263"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -j | --json ]" ID="ID_454824932" CREATED="1564497365521" MODIFIED="1564497377491"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      produce JSON output
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="verify" ID="ID_665811596" CREATED="1551923372697" MODIFIED="1551923749219"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -c | --global-cache ]" ID="ID_1980345697" CREATED="1551923492946" MODIFIED="1564497356522"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Configure global caching behavior
    </p>
  </body>
</html>
</richcontent>
<node TEXT="GLOBAL-CACHE" ID="ID_1738211609" CREATED="1564497336734" MODIFIED="1564497351774"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      'skip' - don't use the global cache
    </p>
    <p>
      'update' - force an update to the global cache
    </p>
  </body>
</html>
</richcontent>
<node TEXT="PACKAGE" ID="ID_1016234334" CREATED="1551923551151" MODIFIED="1551923789673"><richcontent TYPE="DETAILS">

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
</node>
<node TEXT="verify-set" ID="ID_1156355134" CREATED="1551923374153" MODIFIED="1551923823575"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -c | --global-cache ]" ID="ID_582719069" CREATED="1551923492946" MODIFIED="1564497356522"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Configure global caching behavior
    </p>
  </body>
</html>
</richcontent>
<node TEXT="GLOBAL-CACHE" ID="ID_384803498" CREATED="1564497336734" MODIFIED="1564497351774"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      'skip' - don't use the global cache
    </p>
    <p>
      'update' - force an update to the global cache
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
</node>
<node TEXT="upgrade-set" ID="ID_1986471932" CREATED="1551923380937" MODIFIED="1564497455324"><richcontent TYPE="DETAILS">

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
<node TEXT="freeze" ID="ID_1613000043" CREATED="1551923384593" MODIFIED="1551924134460"><richcontent TYPE="DETAILS">

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
</node>
<node TEXT="[Project commands]" ID="ID_751539158" CREATED="1552093055189" MODIFIED="1558495617412">
<node TEXT="init" ID="ID_1019071591" CREATED="1551923356426" MODIFIED="1551923451825"><richcontent TYPE="DETAILS">

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
<node TEXT="[-f | --force ]" ID="ID_497214673" CREATED="1551923452915" MODIFIED="1551923525776"><richcontent TYPE="DETAILS">

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
<node TEXT="repl" ID="ID_124955001" CREATED="1551923376633" MODIFIED="1551923927203"><richcontent TYPE="DETAILS">

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
<node TEXT="" ID="ID_1411721651" CREATED="1551923937034" MODIFIED="1551923937035">
<hook NAME="FirstGroupNode"/>
</node>
<node TEXT="[ -c | --global-cache ]" ID="ID_1687067199" CREATED="1551923492946" MODIFIED="1564497356522"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Configure global caching behavior
    </p>
  </body>
</html>
</richcontent>
<node TEXT="GLOBAL-CACHE" ID="ID_527966710" CREATED="1564497336734" MODIFIED="1564497351774"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      'skip' - don't use the global cache
    </p>
    <p>
      'update' - force an update to the global cache
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="[ -d | --dependency ]" ID="ID_1650264577" CREATED="1564497509283" MODIFIED="1564497515547">
<node TEXT="DEPENDENCY" ID="ID_51447477" CREATED="1564497515917" MODIFIED="1564497530412"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Package name to add to the REPL as dependency
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="[ -p | --path]" ID="ID_1918729421" CREATED="1551923849311" MODIFIED="1551923856188">
<node TEXT="PATH" ID="ID_1812669716" CREATED="1551923874911" MODIFIED="1551923883158"><richcontent TYPE="DETAILS">

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
<node TEXT="" ID="ID_546769477" CREATED="1551923937032" MODIFIED="1551923937034">
<hook NAME="SummaryNode"/>
<hook NAME="AlwaysUnfoldedNode"/>
<node TEXT="--" ID="ID_1280671400" CREATED="1551923986403" MODIFIED="1551923988108">
<node TEXT="[any &apos;purs compile&apos; options]" ID="ID_762803170" CREATED="1551923996105" MODIFIED="1553221138663">
<node TEXT="[ -d | --deps-only ]" ID="ID_1639594554" CREATED="1564497542092" MODIFIED="1564497562833"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Only use sources from dependencies, skipping the project sources
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
</node>
</node>
</node>
<node TEXT="docs" ID="ID_408469387" CREATED="1553221213694" MODIFIED="1553221223291"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -d | --deps-only ]" ID="ID_253493274" CREATED="1564497542092" MODIFIED="1564497562833"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Only use sources from dependencies, skipping the project sources
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -f | --format ]" ID="ID_1810978027" CREATED="1564497591245" MODIFIED="1564497597776">
<node TEXT="FORMAT" ID="ID_87489949" CREATED="1564497598026" MODIFIED="1564497600768"/>
<node TEXT="Docs output format: defaults to &apos;html&apos;&#xa;- markdown&#xa;- html&#xa;- etags&#xa;- ctags" ID="ID_1027866087" CREATED="1564497602222" MODIFIED="1564497632218"/>
</node>
<node TEXT="[ -p | --path]" ID="ID_1399151511" CREATED="1551923849311" MODIFIED="1551923856188">
<node TEXT="PATH" ID="ID_293880751" CREATED="1551923874911" MODIFIED="1553221250973"><richcontent TYPE="DETAILS">

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
<node TEXT="build" ID="ID_710485917" CREATED="1551923375481" MODIFIED="1551923922414"><richcontent TYPE="DETAILS">

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
<node TEXT="" ID="ID_4128123" CREATED="1551923886184" MODIFIED="1551923886184">
<hook NAME="FirstGroupNode"/>
</node>
<node TEXT="[ -p | --path]" ID="ID_1593116742" CREATED="1551923849311" MODIFIED="1553221071487">
<node TEXT="PATH" ID="ID_1717569595" CREATED="1551923874911" MODIFIED="1551923883158"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -w | --watch]" ID="ID_1166494967" CREATED="1553221031133" MODIFIED="1553221045369"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -l | --clear-screen ]" ID="ID_558784638" CREATED="1564497660209" MODIFIED="1564497680232"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Clear the screen on rebuild (watch mode only)
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -n | --no-install ]" ID="ID_688501996" CREATED="1564497682956" MODIFIED="1564497701903"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Don't run the automatic installation of packages
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -d | --deps-only ]" ID="ID_81639445" CREATED="1564497542092" MODIFIED="1564497562833"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Only use sources from dependencies, skipping the project sources
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -c | --global-cache ]" ID="ID_1781148616" CREATED="1551923492946" MODIFIED="1564497356522"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Configure global caching behavior
    </p>
  </body>
</html>
</richcontent>
<node TEXT="GLOBAL-CACHE" ID="ID_354827243" CREATED="1564497336734" MODIFIED="1564497351774"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      'skip' - don't use the global cache
    </p>
    <p>
      'update' - force an update to the global cache
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="" ID="ID_1291536751" CREATED="1551923886183" MODIFIED="1551923886184">
<hook NAME="SummaryNode"/>
<hook NAME="AlwaysUnfoldedNode"/>
<node TEXT="--" ID="ID_354053306" CREATED="1551923886185" MODIFIED="1551923890524">
<node TEXT="[any &apos;purs compile&apos; options]" ID="ID_24762134" CREATED="1551923890896" MODIFIED="1553221155829"/>
</node>
</node>
</node>
<node TEXT="test" ID="ID_212214353" CREATED="1551923377441" MODIFIED="1551924051141"><richcontent TYPE="DETAILS">

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
<node TEXT="" ID="ID_596060183" CREATED="1551923986402" MODIFIED="1551923986403">
<hook NAME="FirstGroupNode"/>
</node>
<node TEXT="[ -a | --node-args ]" ID="ID_1532767671" CREATED="1564497794867" MODIFIED="1564497800528">
<node TEXT="NODE-ARGS" ID="ID_1496411880" CREATED="1564497800793" MODIFIED="1564497815571"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Argument to pass to node (run/test only)
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="[ -m | --main ]" ID="ID_1676639160" CREATED="1551923958208" MODIFIED="1551923963892">
<node TEXT="MAIN" ID="ID_473487240" CREATED="1551923964176" MODIFIED="1551924060408"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -p | --path]" ID="ID_772329126" CREATED="1551923849311" MODIFIED="1551923856188">
<node TEXT="PATH" ID="ID_1570054609" CREATED="1551923874911" MODIFIED="1551923883158"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -w | --watch]" ID="ID_1451350094" CREATED="1553221031133" MODIFIED="1553221045369"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -l | --clear-screen ]" ID="ID_1833551978" CREATED="1564497660209" MODIFIED="1564497680232"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Clear the screen on rebuild (watch mode only)
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -n | --no-install ]" ID="ID_497404745" CREATED="1564497682956" MODIFIED="1564497701903"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Don't run the automatic installation of packages
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -c | --global-cache ]" ID="ID_1732509079" CREATED="1551923492946" MODIFIED="1564497356522"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Configure global caching behavior
    </p>
  </body>
</html>
</richcontent>
<node TEXT="GLOBAL-CACHE" ID="ID_1176303226" CREATED="1564497336734" MODIFIED="1564497351774"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      'skip' - don't use the global cache
    </p>
    <p>
      'update' - force an update to the global cache
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="[ -d | --deps-only ]" ID="ID_426336537" CREATED="1564497542092" MODIFIED="1564497562833"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Only use sources from dependencies, skipping the project sources
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="" ID="ID_182361688" CREATED="1551923986401" MODIFIED="1551923986402">
<hook NAME="SummaryNode"/>
<hook NAME="AlwaysUnfoldedNode"/>
<node TEXT="--" ID="ID_1175340551" CREATED="1551923986403" MODIFIED="1551923988108">
<node TEXT="[any &apos;purs compile&apos; options]" ID="ID_917570627" CREATED="1551923996105" MODIFIED="1553221138663"/>
</node>
</node>
</node>
<node TEXT="run" ID="ID_381109428" CREATED="1551923377441" MODIFIED="1553221114130"><richcontent TYPE="DETAILS">

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
<node TEXT="" ID="ID_746796419" CREATED="1551923986402" MODIFIED="1551923986403">
<hook NAME="FirstGroupNode"/>
</node>
<node TEXT="[ -a | --node-args ]" ID="ID_1364740778" CREATED="1564497794867" MODIFIED="1564497800528">
<node TEXT="NODE-ARGS" ID="ID_1384945032" CREATED="1564497800793" MODIFIED="1564497815571"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Argument to pass to node (run/test only)
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="[ -m | --main ]" ID="ID_1441672691" CREATED="1551923958208" MODIFIED="1551923963892">
<node TEXT="MAIN" ID="ID_1820321046" CREATED="1551923964176" MODIFIED="1551924060408"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -p | --path]" ID="ID_1989986074" CREATED="1551923849311" MODIFIED="1551923856188">
<node TEXT="PATH" ID="ID_684407207" CREATED="1551923874911" MODIFIED="1551923883158"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -w | --watch]" ID="ID_29421353" CREATED="1553221031133" MODIFIED="1553221045369"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -l | --clear-screen ]" ID="ID_828898041" CREATED="1564497660209" MODIFIED="1564497680232"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Clear the screen on rebuild (watch mode only)
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -n | --no-install ]" ID="ID_1051685355" CREATED="1564497682956" MODIFIED="1564497701903"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Don't run the automatic installation of packages
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -c | --global-cache ]" ID="ID_1200332715" CREATED="1551923492946" MODIFIED="1564497356522"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Configure global caching behavior
    </p>
  </body>
</html>
</richcontent>
<node TEXT="GLOBAL-CACHE" ID="ID_115635532" CREATED="1564497336734" MODIFIED="1564497351774"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      'skip' - don't use the global cache
    </p>
    <p>
      'update' - force an update to the global cache
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="[ -d | --deps-only ]" ID="ID_841979272" CREATED="1564497542092" MODIFIED="1564497562833"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Only use sources from dependencies, skipping the project sources
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="" ID="ID_581913189" CREATED="1551923986401" MODIFIED="1551923986402">
<hook NAME="SummaryNode"/>
<hook NAME="AlwaysUnfoldedNode"/>
<node TEXT="--" ID="ID_845177579" CREATED="1551923986403" MODIFIED="1551923988108">
<node TEXT="[any &apos;purs compile&apos; options]" ID="ID_1995890420" CREATED="1551923996105" MODIFIED="1553221138663"/>
</node>
</node>
</node>
<node TEXT="" ID="ID_499508907" CREATED="1553221400501" MODIFIED="1553221400502">
<hook NAME="FirstGroupNode"/>
</node>
<node TEXT="bundle-app" ID="ID_1249446139" CREATED="1551923378169" MODIFIED="1558495662075"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -m | --main ]" ID="ID_18539015" CREATED="1551923958208" MODIFIED="1551923963892">
<node TEXT="MAIN" ID="ID_1557177990" CREATED="1551923964176" MODIFIED="1558495716864"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Module with a `main :: Effect Unit` function,
    </p>
    <p>
      which is used as the application's entry point
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="[ -t | --to ]" ID="ID_1427749301" CREATED="1551924016257" MODIFIED="1551924024566">
<node TEXT="TO" ID="ID_1038675789" CREATED="1551924025017" MODIFIED="1551924030373"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -s | --no-build ]" ID="ID_1275411071" CREATED="1553221309505" MODIFIED="1553221322616"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -p | --path]" ID="ID_265042662" CREATED="1551923849311" MODIFIED="1551923856188">
<node TEXT="PATH" ID="ID_1430578845" CREATED="1551923874911" MODIFIED="1551923883158"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -w | --watch]" ID="ID_698583473" CREATED="1553221031133" MODIFIED="1553221045369"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -w | --watch]" ID="ID_131464460" CREATED="1553221031133" MODIFIED="1553221045369"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -l | --clear-screen ]" ID="ID_1629656838" CREATED="1564497660209" MODIFIED="1564497680232"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Clear the screen on rebuild (watch mode only)
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -n | --no-install ]" ID="ID_822688098" CREATED="1564497682956" MODIFIED="1564497701903"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Don't run the automatic installation of packages
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -c | --global-cache ]" ID="ID_1647983347" CREATED="1551923492946" MODIFIED="1564497356522"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Configure global caching behavior
    </p>
  </body>
</html>
</richcontent>
<node TEXT="GLOBAL-CACHE" ID="ID_1798518867" CREATED="1564497336734" MODIFIED="1564497351774"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      'skip' - don't use the global cache
    </p>
    <p>
      'update' - force an update to the global cache
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="[ -d | --deps-only ]" ID="ID_647520094" CREATED="1564497542092" MODIFIED="1564497562833"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Only use sources from dependencies, skipping the project sources
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="" ID="ID_1562177962" CREATED="1553221400499" MODIFIED="1553221400501">
<hook NAME="SummaryNode"/>
<hook NAME="AlwaysUnfoldedNode"/>
<node TEXT="--" ID="ID_1567106703" CREATED="1551923986403" MODIFIED="1551923988108">
<node TEXT="[any &apos;purs compile&apos; options]" ID="ID_1670237497" CREATED="1551923996105" MODIFIED="1553221144050"/>
</node>
</node>
<node TEXT="" ID="ID_700251502" CREATED="1553221438415" MODIFIED="1553221438415">
<hook NAME="FirstGroupNode"/>
</node>
<node TEXT="bundle-module" ID="ID_1713216659" CREATED="1551923379385" MODIFIED="1564497953500"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -m | --main ]" ID="ID_1213997369" CREATED="1551923958208" MODIFIED="1551923963892">
<node TEXT="MAIN" ID="ID_820923926" CREATED="1551923964176" MODIFIED="1558495761417"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Module which is used as the application's entry point
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="[ -t | --to ]" ID="ID_909194186" CREATED="1551924016257" MODIFIED="1551924024566">
<node TEXT="TO" ID="ID_1585752804" CREATED="1551924025017" MODIFIED="1551924030373"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -s | --no-build ]" ID="ID_1512087943" CREATED="1553221309505" MODIFIED="1553221322616"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -j | --jobs ]" ID="ID_334128720" CREATED="1551923492946" MODIFIED="1551923595223"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -p | --path]" ID="ID_954480389" CREATED="1551923849311" MODIFIED="1551923856188">
<node TEXT="PATH" ID="ID_1676820286" CREATED="1551923874911" MODIFIED="1551923883158"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -w | --watch]" ID="ID_139255485" CREATED="1553221031133" MODIFIED="1553221045369"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -w | --watch]" ID="ID_426823366" CREATED="1553221031133" MODIFIED="1553221045369"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -l | --clear-screen ]" ID="ID_707069449" CREATED="1564497660209" MODIFIED="1564497680232"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Clear the screen on rebuild (watch mode only)
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -n | --no-install ]" ID="ID_1536075493" CREATED="1564497682956" MODIFIED="1564497701903"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Don't run the automatic installation of packages
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -c | --global-cache ]" ID="ID_1842873471" CREATED="1551923492946" MODIFIED="1564497356522"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Configure global caching behavior
    </p>
  </body>
</html>
</richcontent>
<node TEXT="GLOBAL-CACHE" ID="ID_731927543" CREATED="1564497336734" MODIFIED="1564497351774"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      'skip' - don't use the global cache
    </p>
    <p>
      'update' - force an update to the global cache
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="[ -d | --deps-only ]" ID="ID_135628948" CREATED="1564497542092" MODIFIED="1564497562833"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Only use sources from dependencies, skipping the project sources
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="" ID="ID_1239420374" CREATED="1553221438414" MODIFIED="1553221438415">
<hook NAME="SummaryNode"/>
<hook NAME="AlwaysUnfoldedNode"/>
<node TEXT="--" ID="ID_547282441" CREATED="1551923986403" MODIFIED="1551923988108">
<node TEXT="[any &apos;purs compile&apos; options]" ID="ID_1842703466" CREATED="1551923996105" MODIFIED="1553221144050"/>
</node>
</node>
</node>
<node TEXT="[Other commands]" ID="ID_1212879556" CREATED="1552093096477" MODIFIED="1558495610520">
<node TEXT="version" ID="ID_1749138769" CREATED="1551923395002" MODIFIED="1551924228905"><richcontent TYPE="DETAILS">

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
<node TEXT="[Psc-Package compatibility commands]" ID="ID_1816277994" CREATED="1552092321492" MODIFIED="1558495625915">
<node TEXT="psc-package-local-setup" ID="ID_130718955" CREATED="1551923385858" MODIFIED="1551924158465"><richcontent TYPE="DETAILS">

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
<node TEXT="[-f | --force ]" ID="ID_1995805925" CREATED="1551923452915" MODIFIED="1551923525776"><richcontent TYPE="DETAILS">

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
<node TEXT="psc-package-insdhall" ID="ID_1459513997" CREATED="1551923389073" MODIFIED="1551924197486"><richcontent TYPE="DETAILS">

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
<node TEXT="psc-package-clean" ID="ID_1355193552" CREATED="1551923392762" MODIFIED="1551924215009"><richcontent TYPE="DETAILS">

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
</node>
</node>
<node TEXT="" ID="ID_13446128" CREATED="1564497083593" MODIFIED="1582232227987">
<hook NAME="FirstGroupNode"/>
</node>
<node TEXT="version 0.12.1.0" ID="ID_1615857977" CREATED="1564497039392" MODIFIED="1582232228011"/>
<node TEXT="" ID="ID_743321990" CREATED="1564497083587" MODIFIED="1582232228025">
<hook NAME="SummaryNode"/>
<hook NAME="AlwaysUnfoldedNode"/>
<node TEXT="global options" FOLDED="true" ID="ID_117769515" CREATED="1582232216431" MODIFIED="1582232220853">
<node TEXT="" ID="ID_978269870" CREATED="1564497147002" MODIFIED="1564497147005">
<hook NAME="FirstGroupNode"/>
</node>
<node TEXT="[ -h | --help ]" ID="ID_1186867554" CREATED="1558495443616" MODIFIED="1564498063850"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Show the help text
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -v | --verbose ]" ID="ID_1018057959" CREATED="1558495447399" MODIFIED="1564498081747"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Enable additional debug logging (e.g. print the `purs` commands)
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -V | --very-verbose ]" ID="ID_807123714" CREATED="1558495447399" MODIFIED="1574049446156"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Enables more verbosity: timestamps and source locations
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -P, --no-psa ]" ID="ID_524528215" CREATED="1564497099049" MODIFIED="1574049429206"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Don't build with 'psa', but use 'purs'
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -j, --jobs ]" ID="ID_1871792087" CREATED="1564497118701" MODIFIED="1564498090908"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -x, --config]" ID="ID_480254412" CREATED="1574049456582" MODIFIED="1574049503130"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Specifies the path to the config file
    </p>
    <p>
      Default: `spago.dhall` file.
    </p>
  </body>
</html>
</richcontent>
<node TEXT="CONFIG" ID="ID_1064003764" CREATED="1574049462922" MODIFIED="1574049464680"/>
</node>
<node TEXT="" ID="ID_999834194" CREATED="1564497146997" MODIFIED="1564497147001">
<hook NAME="SummaryNode"/>
<hook NAME="AlwaysUnfoldedNode"/>
<node TEXT="commands" FOLDED="true" ID="ID_1616733136" CREATED="1564497147007" MODIFIED="1564497180472">
<node TEXT="[Package set commands]" ID="ID_1440117617" CREATED="1552093036357" MODIFIED="1558495605739">
<node TEXT="install" ID="ID_1200995259" CREATED="1551923368362" MODIFIED="1558495559218"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Install (download) all dependencies listed in `spago.dhall` file
    </p>
  </body>
</html>
</richcontent>
<node TEXT="[ -c | --global-cache ]" ID="ID_147867282" CREATED="1551923492946" MODIFIED="1564497356522"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Configure global caching behavior
    </p>
  </body>
</html>
</richcontent>
<node TEXT="GLOBAL-CACHE" ID="ID_1976979255" CREATED="1564497336734" MODIFIED="1564497351774"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      'skip' - don't use the global cache
    </p>
    <p>
      'update' - force an update to the global cache
    </p>
  </body>
</html>
</richcontent>
<node TEXT="PACKAGE" ID="ID_646591636" CREATED="1551923551151" MODIFIED="1551923562409"><richcontent TYPE="DETAILS">

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
<node TEXT="sources" ID="ID_1535963071" CREATED="1551923369609" MODIFIED="1551923611658"><richcontent TYPE="DETAILS">

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
<node TEXT="list-packages" ID="ID_1506771890" CREATED="1551923370817" MODIFIED="1552092619411"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -f | --filter ]" ID="ID_850984342" CREATED="1551923629012" MODIFIED="1551923669418">
<node TEXT="FILTER" ID="ID_91229766" CREATED="1551923670373" MODIFIED="1551923695263"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -j | --json ]" ID="ID_1775692076" CREATED="1564497365521" MODIFIED="1564497377491"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      produce JSON output
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="verify" ID="ID_222845542" CREATED="1551923372697" MODIFIED="1551923749219"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -c | --global-cache ]" ID="ID_551304547" CREATED="1551923492946" MODIFIED="1564497356522"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Configure global caching behavior
    </p>
  </body>
</html>
</richcontent>
<node TEXT="GLOBAL-CACHE" ID="ID_1193113842" CREATED="1564497336734" MODIFIED="1564497351774"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      'skip' - don't use the global cache
    </p>
    <p>
      'update' - force an update to the global cache
    </p>
  </body>
</html>
</richcontent>
<node TEXT="PACKAGE" ID="ID_1262790593" CREATED="1551923551151" MODIFIED="1551923789673"><richcontent TYPE="DETAILS">

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
</node>
<node TEXT="verify-set" ID="ID_1800410827" CREATED="1551923374153" MODIFIED="1551923823575"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -c | --global-cache ]" ID="ID_1417186296" CREATED="1551923492946" MODIFIED="1564497356522"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Configure global caching behavior
    </p>
  </body>
</html>
</richcontent>
<node TEXT="GLOBAL-CACHE" ID="ID_696554587" CREATED="1564497336734" MODIFIED="1564497351774"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      'skip' - don't use the global cache
    </p>
    <p>
      'update' - force an update to the global cache
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="[ -M | --no-check-modules-unique ]" ID="ID_1975459730" CREATED="1574049622959" MODIFIED="1574049644786"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Skip checking whether modules names are unique across all packages
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="upgrade-set" ID="ID_766429895" CREATED="1551923380937" MODIFIED="1564497455324"><richcontent TYPE="DETAILS">

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
<node TEXT="freeze" ID="ID_915675965" CREATED="1551923384593" MODIFIED="1574049674150"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Recompute the hashes for the package-set
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="[Project commands]" ID="ID_1688137791" CREATED="1552093055189" MODIFIED="1558495617412">
<node TEXT="init" ID="ID_1175399565" CREATED="1551923356426" MODIFIED="1551923451825"><richcontent TYPE="DETAILS">

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
<node TEXT="[-f | --force ]" ID="ID_1566924586" CREATED="1551923452915" MODIFIED="1551923525776"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -C | --no-comments ]" ID="ID_730032541" CREATED="1574049694665" MODIFIED="1574049714820"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Generate package.dhall and spago.dhall files without tutorial comments
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="repl" ID="ID_10516900" CREATED="1551923376633" MODIFIED="1551923927203"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -c | --global-cache ]" ID="ID_1997970240" CREATED="1551923492946" MODIFIED="1564497356522"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Configure global caching behavior
    </p>
  </body>
</html>
</richcontent>
<node TEXT="GLOBAL-CACHE" ID="ID_1576590644" CREATED="1564497336734" MODIFIED="1564497351774"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      'skip' - don't use the global cache
    </p>
    <p>
      'update' - force an update to the global cache
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="[ -D | --dependency ]" ID="ID_562545960" CREATED="1564497509283" MODIFIED="1574049736882">
<node TEXT="DEPENDENCY" ID="ID_42830767" CREATED="1564497515917" MODIFIED="1564497530412"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Package name to add to the REPL as dependency
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="[ -d | -- deps-only ]" ID="ID_1032325393" CREATED="1574049761633" MODIFIED="1574049779542"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Only use sources from dependencies, skipping the project sources
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -p | --path]" ID="ID_373440479" CREATED="1551923849311" MODIFIED="1551923856188">
<node TEXT="PATH" ID="ID_393372920" CREATED="1551923874911" MODIFIED="1551923883158"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -u | --purs-args ]" ID="ID_1666997603" CREATED="1574049739584" MODIFIED="1574049756158"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Argument to pass to `purs`
    </p>
  </body>
</html>
</richcontent>
<node TEXT="PURS-ARGS" ID="ID_222459899" CREATED="1574049747177" MODIFIED="1574049750853"/>
</node>
</node>
<node TEXT="docs" ID="ID_1229767984" CREATED="1553221213694" MODIFIED="1553221223291"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -f | --format ]" ID="ID_453483639" CREATED="1564497591245" MODIFIED="1564497597776">
<node TEXT="FORMAT" ID="ID_1017145324" CREATED="1564497598026" MODIFIED="1564497600768"/>
<node TEXT="Docs output format: defaults to &apos;html&apos;&#xa;- markdown&#xa;- html&#xa;- etags&#xa;- ctags" ID="ID_516650067" CREATED="1564497602222" MODIFIED="1564497632218"/>
</node>
<node TEXT="[ -p | --path]" ID="ID_99198530" CREATED="1551923849311" MODIFIED="1551923856188">
<node TEXT="PATH" ID="ID_1042219290" CREATED="1551923874911" MODIFIED="1553221250973"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -d | --deps-only ]" ID="ID_576177894" CREATED="1564497542092" MODIFIED="1564497562833"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Only use sources from dependencies, skipping the project sources
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -S | --no-search ]" ID="ID_955120273" CREATED="1574050409966" MODIFIED="1574050425239"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Do not make documentation searchable
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -o | --open ]" ID="ID_961529279" CREATED="1574050425629" MODIFIED="1574050441324"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Open generated documentation in browser (for HTML format only)
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="build" ID="ID_1065286444" CREATED="1551923375481" MODIFIED="1551923922414"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -c | --global-cache ]" ID="ID_1754469882" CREATED="1551923492946" MODIFIED="1564497356522"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Configure global caching behavior
    </p>
  </body>
</html>
</richcontent>
<node TEXT="GLOBAL-CACHE" ID="ID_1709140226" CREATED="1564497336734" MODIFIED="1564497351774"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      'skip' - don't use the global cache
    </p>
    <p>
      'update' - force an update to the global cache
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="[ -w | --watch]" ID="ID_1354540143" CREATED="1553221031133" MODIFIED="1553221045369"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -l | --clear-screen ]" ID="ID_1844879190" CREATED="1564497660209" MODIFIED="1564497680232"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Clear the screen on rebuild (watch mode only)
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -p | --path]" ID="ID_167557042" CREATED="1551923849311" MODIFIED="1553221071487">
<node TEXT="PATH" ID="ID_46174581" CREATED="1551923874911" MODIFIED="1551923883158"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -n | --no-install ]" ID="ID_144790357" CREATED="1564497682956" MODIFIED="1564497701903"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Don't run the automatic installation of packages
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -u | --purs-args ]" ID="ID_669062663" CREATED="1574049739584" MODIFIED="1574049756158"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Argument to pass to `purs`
    </p>
  </body>
</html>
</richcontent>
<node TEXT="PURS-ARGS" ID="ID_786464904" CREATED="1574049747177" MODIFIED="1574049750853"/>
</node>
<node TEXT="[ -d | --deps-only ]" ID="ID_1321693936" CREATED="1564497542092" MODIFIED="1564497562833"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Only use sources from dependencies, skipping the project sources
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -S | --no-share-output ]" ID="ID_1920988840" CREATED="1574049845328" MODIFIED="1574049887731"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Disable using a shared output folder in location of root `packages.dhall` (e.g. when using monorepo)
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="search" ID="ID_883836196" CREATED="1574050460344" MODIFIED="1574050472677"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Start a search REPL to find definitions matching names and types
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="" ID="ID_999402089" CREATED="1574050501535" MODIFIED="1574050501537">
<hook NAME="FirstGroupNode"/>
</node>
<node TEXT="path" ID="ID_831182699" CREATED="1574050482114" MODIFIED="1574050495508"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Prints all paths used in Spago
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="" ID="ID_1086897290" CREATED="1574050501532" MODIFIED="1574050501535">
<hook NAME="SummaryNode"/>
<hook NAME="AlwaysUnfoldedNode"/>
<node TEXT="output" ID="ID_898544567" CREATED="1574050501537" MODIFIED="1574050550724"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      prints the path used for the `purs` compiler's output
    </p>
    <p>
      (note: this is intended to be used by tools)
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="test" ID="ID_455535066" CREATED="1551923377441" MODIFIED="1551924051141"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -m | --main ]" ID="ID_1718084312" CREATED="1551923958208" MODIFIED="1551923963892">
<node TEXT="MAIN" ID="ID_11872125" CREATED="1551923964176" MODIFIED="1551924060408"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -c | --global-cache ]" ID="ID_600997485" CREATED="1551923492946" MODIFIED="1564497356522"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Configure global caching behavior
    </p>
  </body>
</html>
</richcontent>
<node TEXT="GLOBAL-CACHE" ID="ID_938975456" CREATED="1564497336734" MODIFIED="1564497351774"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      'skip' - don't use the global cache
    </p>
    <p>
      'update' - force an update to the global cache
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="[ -w | --watch]" ID="ID_706826292" CREATED="1553221031133" MODIFIED="1553221045369"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -l | --clear-screen ]" ID="ID_1398526588" CREATED="1564497660209" MODIFIED="1564497680232"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Clear the screen on rebuild (watch mode only)
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -p | --path]" ID="ID_137887980" CREATED="1551923849311" MODIFIED="1551923856188">
<node TEXT="PATH" ID="ID_1654156349" CREATED="1551923874911" MODIFIED="1551923883158"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -n | --no-install ]" ID="ID_135013668" CREATED="1564497682956" MODIFIED="1564497701903"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Don't run the automatic installation of packages
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -u | --purs-args ]" ID="ID_664947042" CREATED="1574049739584" MODIFIED="1574049756158"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Argument to pass to `purs`
    </p>
  </body>
</html>
</richcontent>
<node TEXT="PURS-ARGS" ID="ID_1748869314" CREATED="1574049747177" MODIFIED="1574049750853"/>
</node>
<node TEXT="[ -d | --deps-only ]" ID="ID_1276354697" CREATED="1564497542092" MODIFIED="1564497562833"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Only use sources from dependencies, skipping the project sources
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -S | --no-share-output ]" ID="ID_1825204560" CREATED="1574049845328" MODIFIED="1574049887731"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Disable using a shared output folder in location of root `packages.dhall` (e.g. when using monorepo)
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -a | --node-args ]" ID="ID_1362828614" CREATED="1564497794867" MODIFIED="1564497800528">
<node TEXT="NODE-ARGS" ID="ID_1422369677" CREATED="1564497800793" MODIFIED="1564497815571"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Argument to pass to node (run/test only)
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
</node>
<node TEXT="run" ID="ID_735224827" CREATED="1551923377441" MODIFIED="1553221114130"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -m | --main ]" ID="ID_1057565034" CREATED="1551923958208" MODIFIED="1551923963892">
<node TEXT="MAIN" ID="ID_376442617" CREATED="1551923964176" MODIFIED="1574049974389"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -c | --global-cache ]" ID="ID_1086274478" CREATED="1551923492946" MODIFIED="1564497356522"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Configure global caching behavior
    </p>
  </body>
</html>
</richcontent>
<node TEXT="GLOBAL-CACHE" ID="ID_1374344375" CREATED="1564497336734" MODIFIED="1564497351774"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      'skip' - don't use the global cache
    </p>
    <p>
      'update' - force an update to the global cache
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="[ -w | --watch]" ID="ID_785485793" CREATED="1553221031133" MODIFIED="1553221045369"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -l | --clear-screen ]" ID="ID_1013535652" CREATED="1564497660209" MODIFIED="1564497680232"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Clear the screen on rebuild (watch mode only)
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -p | --path]" ID="ID_44746283" CREATED="1551923849311" MODIFIED="1551923856188">
<node TEXT="PATH" ID="ID_630258036" CREATED="1551923874911" MODIFIED="1551923883158"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -n | --no-install ]" ID="ID_1781164919" CREATED="1564497682956" MODIFIED="1564497701903"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Don't run the automatic installation of packages
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -u | --purs-args ]" ID="ID_1700144136" CREATED="1574049739584" MODIFIED="1574049756158"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Argument to pass to `purs`
    </p>
  </body>
</html>
</richcontent>
<node TEXT="PURS-ARGS" ID="ID_333585918" CREATED="1574049747177" MODIFIED="1574049750853"/>
</node>
<node TEXT="[ -d | --deps-only ]" ID="ID_1331142801" CREATED="1564497542092" MODIFIED="1564497562833"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Only use sources from dependencies, skipping the project sources
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -S | --no-share-output ]" ID="ID_1529516495" CREATED="1574049845328" MODIFIED="1574049887731"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Disable using a shared output folder in location of root `packages.dhall` (e.g. when using monorepo)
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -a | --node-args ]" ID="ID_1036143862" CREATED="1564497794867" MODIFIED="1564497800528">
<node TEXT="NODE-ARGS" ID="ID_287090665" CREATED="1564497800793" MODIFIED="1564497815571"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Argument to pass to node (run/test only)
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
</node>
<node TEXT="bundle-app" ID="ID_1670187198" CREATED="1551923378169" MODIFIED="1558495662075"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -m | --main ]" ID="ID_1156476677" CREATED="1551923958208" MODIFIED="1551923963892">
<node TEXT="MAIN" ID="ID_1899385699" CREATED="1551923964176" MODIFIED="1558495716864"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Module with a `main :: Effect Unit` function,
    </p>
    <p>
      which is used as the application's entry point
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="[ -t | --to ]" ID="ID_1345964495" CREATED="1551924016257" MODIFIED="1551924024566">
<node TEXT="TO" ID="ID_1117240651" CREATED="1551924025017" MODIFIED="1551924030373"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -s | --no-build ]" ID="ID_1645793157" CREATED="1553221309505" MODIFIED="1553221322616"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -c | --global-cache ]" ID="ID_1226505288" CREATED="1551923492946" MODIFIED="1564497356522"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Configure global caching behavior
    </p>
  </body>
</html>
</richcontent>
<node TEXT="GLOBAL-CACHE" ID="ID_1923586028" CREATED="1564497336734" MODIFIED="1564497351774"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      'skip' - don't use the global cache
    </p>
    <p>
      'update' - force an update to the global cache
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="[ -w | --watch]" ID="ID_1469940310" CREATED="1553221031133" MODIFIED="1553221045369"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -l | --clear-screen ]" ID="ID_1479517929" CREATED="1564497660209" MODIFIED="1564497680232"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Clear the screen on rebuild (watch mode only)
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -p | --path]" ID="ID_853594295" CREATED="1551923849311" MODIFIED="1551923856188">
<node TEXT="PATH" ID="ID_498124064" CREATED="1551923874911" MODIFIED="1551923883158"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -n | --no-install ]" ID="ID_1909506332" CREATED="1564497682956" MODIFIED="1564497701903"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Don't run the automatic installation of packages
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -u | --purs-args ]" ID="ID_528094615" CREATED="1574049739584" MODIFIED="1574049756158"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Argument to pass to `purs`
    </p>
  </body>
</html>
</richcontent>
<node TEXT="PURS-ARGS" ID="ID_1458544791" CREATED="1574049747177" MODIFIED="1574049750853"/>
</node>
<node TEXT="[ -d | --deps-only ]" ID="ID_1299900381" CREATED="1564497542092" MODIFIED="1564497562833"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Only use sources from dependencies, skipping the project sources
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -S | --no-share-output ]" ID="ID_400032116" CREATED="1574049845328" MODIFIED="1574049887731"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Disable using a shared output folder in location of root `packages.dhall` (e.g. when using monorepo)
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="bundle-module" ID="ID_932314531" CREATED="1551923379385" MODIFIED="1564497953500"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -m | --main ]" ID="ID_1457046108" CREATED="1551923958208" MODIFIED="1551923963892">
<node TEXT="MAIN" ID="ID_1181623785" CREATED="1551923964176" MODIFIED="1558495761417"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Module which is used as the application's entry point
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="[ -t | --to ]" ID="ID_1496897433" CREATED="1551924016257" MODIFIED="1551924024566">
<node TEXT="TO" ID="ID_1726375563" CREATED="1551924025017" MODIFIED="1551924030373"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -s | --no-build ]" ID="ID_2399360" CREATED="1553221309505" MODIFIED="1553221322616"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -c | --global-cache ]" ID="ID_1203505268" CREATED="1551923492946" MODIFIED="1564497356522"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Configure global caching behavior
    </p>
  </body>
</html>
</richcontent>
<node TEXT="GLOBAL-CACHE" ID="ID_29057611" CREATED="1564497336734" MODIFIED="1564497351774"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      'skip' - don't use the global cache
    </p>
    <p>
      'update' - force an update to the global cache
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="[ -w | --watch]" ID="ID_1874343386" CREATED="1553221031133" MODIFIED="1553221045369"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -l | --clear-screen ]" ID="ID_875908885" CREATED="1564497660209" MODIFIED="1564497680232"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Clear the screen on rebuild (watch mode only)
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -p | --path]" ID="ID_118377562" CREATED="1551923849311" MODIFIED="1551923856188">
<node TEXT="PATH" ID="ID_1478403032" CREATED="1551923874911" MODIFIED="1551923883158"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -n | --no-install ]" ID="ID_1922595797" CREATED="1564497682956" MODIFIED="1564497701903"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Don't run the automatic installation of packages
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -u | --purs-args ]" ID="ID_1879591101" CREATED="1574049739584" MODIFIED="1574049756158"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Argument to pass to `purs`
    </p>
  </body>
</html>
</richcontent>
<node TEXT="PURS-ARGS" ID="ID_1619016556" CREATED="1574049747177" MODIFIED="1574049750853"/>
</node>
<node TEXT="[ -d | --deps-only ]" ID="ID_1212378255" CREATED="1564497542092" MODIFIED="1564497562833"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Only use sources from dependencies, skipping the project sources
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -S | --no-share-output ]" ID="ID_580184403" CREATED="1574049845328" MODIFIED="1574049887731"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Disable using a shared output folder in location of root `packages.dhall` (e.g. when using monorepo)
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
</node>
<node TEXT="[Other commands]" ID="ID_1269592528" CREATED="1552093096477" MODIFIED="1558495610520">
<node TEXT="version" ID="ID_1569023357" CREATED="1551923395002" MODIFIED="1551924228905"><richcontent TYPE="DETAILS">

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
</node>
</node>
</node>
</node>
</node>
<node TEXT="version 0.14.0" POSITION="right" ID="ID_986910239" CREATED="1582231329407" MODIFIED="1582231338397">
<edge COLOR="#007c7c"/>
<node TEXT="" ID="ID_1371032667" CREATED="1564497147002" MODIFIED="1564497147005">
<hook NAME="FirstGroupNode"/>
</node>
<node TEXT="[ -h | --help ]" ID="ID_313763486" CREATED="1558495443616" MODIFIED="1564498063850"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Show the help text
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -q, --quiet]" ID="ID_1310898047" CREATED="1582231360729" MODIFIED="1582231389602"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Suppress all Spago logging
    </p>
  </body>
</html>

</richcontent>
</node>
<node TEXT="[ -v | --verbose ]" ID="ID_201095431" CREATED="1558495447399" MODIFIED="1564498081747"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Enable additional debug logging (e.g. print the `purs` commands)
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -V | --very-verbose ]" ID="ID_1941210317" CREATED="1558495447399" MODIFIED="1574049446156"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Enables more verbosity: timestamps and source locations
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -C, --no-color ]" ID="ID_1437007033" CREATED="1582231393854" MODIFIED="1582231408840"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Log without ANSI color escapes
    </p>
  </body>
</html>

</richcontent>
</node>
<node TEXT="[ -P, --no-psa ]" ID="ID_1452562073" CREATED="1564497099049" MODIFIED="1574049429206"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Don't build with 'psa', but use 'purs'
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -j, --jobs ]" ID="ID_1597627920" CREATED="1564497118701" MODIFIED="1564498090908"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -x, --config]" ID="ID_84175056" CREATED="1574049456582" MODIFIED="1574049503130"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Specifies the path to the config file
    </p>
    <p>
      Default: `spago.dhall` file.
    </p>
  </body>
</html>
</richcontent>
<node TEXT="CONFIG" ID="ID_1379178127" CREATED="1574049462922" MODIFIED="1574049464680"/>
</node>
<node TEXT="" ID="ID_1502480488" CREATED="1564497146997" MODIFIED="1564497147001">
<hook NAME="SummaryNode"/>
<hook NAME="AlwaysUnfoldedNode"/>
<node TEXT="commands" ID="ID_1710539044" CREATED="1564497147007" MODIFIED="1564497180472">
<node TEXT="[Project commands]" ID="ID_143318953" CREATED="1552093055189" MODIFIED="1558495617412">
<node TEXT="init" ID="ID_1297328681" CREATED="1551923356426" MODIFIED="1551923451825"><richcontent TYPE="DETAILS">

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
<node TEXT="[-f | --force ]" ID="ID_671845328" CREATED="1551923452915" MODIFIED="1551923525776"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -C | --no-comments ]" ID="ID_1627115978" CREATED="1574049694665" MODIFIED="1574049714820"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Generate package.dhall and spago.dhall files without tutorial comments
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="repl" ID="ID_422184635" CREATED="1551923376633" MODIFIED="1551923927203"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -c | --global-cache ]" ID="ID_1997672540" CREATED="1551923492946" MODIFIED="1564497356522"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Configure global caching behavior
    </p>
  </body>
</html>
</richcontent>
<node TEXT="GLOBAL-CACHE" ID="ID_563053058" CREATED="1564497336734" MODIFIED="1564497351774"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      'skip' - don't use the global cache
    </p>
    <p>
      'update' - force an update to the global cache
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="[ -D | --dependency ]" ID="ID_691935893" CREATED="1564497509283" MODIFIED="1574049736882">
<node TEXT="DEPENDENCY" ID="ID_956717359" CREATED="1564497515917" MODIFIED="1564497530412"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Package name to add to the REPL as dependency
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="[ -p | --path]" ID="ID_466298827" CREATED="1551923849311" MODIFIED="1551923856188">
<node TEXT="PATH" ID="ID_463684607" CREATED="1551923874911" MODIFIED="1551923883158"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -u | --purs-args ]" ID="ID_1167689932" CREATED="1574049739584" MODIFIED="1574049756158"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Argument to pass to `purs`
    </p>
  </body>
</html>
</richcontent>
<node TEXT="PURS-ARGS" ID="ID_1881233032" CREATED="1574049747177" MODIFIED="1574049750853"/>
</node>
<node TEXT="[ -d | -- deps-only ]" ID="ID_133548572" CREATED="1574049761633" MODIFIED="1574049779542"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Only use sources from dependencies, skipping the project sources
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="sources" ID="ID_1705796766" CREATED="1551923369609" MODIFIED="1551923611658"><richcontent TYPE="DETAILS">

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
<node TEXT="docs" ID="ID_1124002296" CREATED="1553221213694" MODIFIED="1553221223291"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -f | --format ]" ID="ID_1118726016" CREATED="1564497591245" MODIFIED="1564497597776">
<node TEXT="FORMAT" ID="ID_912454113" CREATED="1564497598026" MODIFIED="1564497600768"/>
<node TEXT="Docs output format: defaults to &apos;html&apos;&#xa;- markdown&#xa;- html&#xa;- etags&#xa;- ctags" ID="ID_747937140" CREATED="1564497602222" MODIFIED="1564497632218"/>
</node>
<node TEXT="[ -p | --path]" ID="ID_1374910570" CREATED="1551923849311" MODIFIED="1551923856188">
<node TEXT="PATH" ID="ID_241543504" CREATED="1551923874911" MODIFIED="1553221250973"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -d | --deps-only ]" ID="ID_1305495463" CREATED="1564497542092" MODIFIED="1564497562833"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Only use sources from dependencies, skipping the project sources
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -S | --no-search ]" ID="ID_192307493" CREATED="1574050409966" MODIFIED="1574050425239"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Do not make documentation searchable
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -o | --open ]" ID="ID_1155812939" CREATED="1574050425629" MODIFIED="1574050441324"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Open generated documentation in browser (for HTML format only)
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="build" ID="ID_581116334" CREATED="1551923375481" MODIFIED="1551923922414"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -c | --global-cache ]" ID="ID_1602315459" CREATED="1551923492946" MODIFIED="1564497356522"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Configure global caching behavior
    </p>
  </body>
</html>
</richcontent>
<node TEXT="GLOBAL-CACHE" ID="ID_1781877596" CREATED="1564497336734" MODIFIED="1564497351774"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      'skip' - don't use the global cache
    </p>
    <p>
      'update' - force an update to the global cache
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="[ -w | --watch]" ID="ID_264163533" CREATED="1553221031133" MODIFIED="1553221045369"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -l | --clear-screen ]" ID="ID_1770086887" CREATED="1564497660209" MODIFIED="1564497680232"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Clear the screen on rebuild (watch mode only)
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -p | --path]" ID="ID_1545452495" CREATED="1551923849311" MODIFIED="1553221071487">
<node TEXT="PATH" ID="ID_1518293098" CREATED="1551923874911" MODIFIED="1551923883158"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -x | --source-maps ]" ID="ID_1334356340" CREATED="1582232519588" MODIFIED="1582232534915"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Whether to generate source maps for the bundle
    </p>
  </body>
</html>

</richcontent>
</node>
<node TEXT="[ -n | --no-install ]" ID="ID_1502848860" CREATED="1564497682956" MODIFIED="1564497701903"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Don't run the automatic installation of packages
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -u | --purs-args ]" ID="ID_575616152" CREATED="1574049739584" MODIFIED="1574049756158"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Argument to pass to `purs`
    </p>
  </body>
</html>
</richcontent>
<node TEXT="PURS-ARGS" ID="ID_1850502601" CREATED="1574049747177" MODIFIED="1574049750853"/>
</node>
<node TEXT="[ -d | --deps-only ]" ID="ID_17625312" CREATED="1564497542092" MODIFIED="1564497562833"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Only use sources from dependencies, skipping the project sources
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -S | --no-share-output ]" ID="ID_1790463408" CREATED="1574049845328" MODIFIED="1574049887731"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Disable using a shared output folder in location of root `packages.dhall` (e.g. when using monorepo)
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -b, --before ]" ID="ID_1838431714" CREATED="1582231970165" MODIFIED="1582231977130">
<node TEXT="BEFORE" ID="ID_765682274" CREATED="1582231977572" MODIFIED="1582232006697"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Commands to run before a build
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="[ -t, --then ]" ID="ID_1655537802" CREATED="1582231983800" MODIFIED="1582231988468">
<node TEXT="THEN" ID="ID_850407036" CREATED="1582231988674" MODIFIED="1582232014318"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Commands to run following a successful build
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="[ -e, --else ]" ID="ID_1705314978" CREATED="1582231992417" MODIFIED="1582231996529">
<node TEXT="ELSE" ID="ID_907827486" CREATED="1582231996823" MODIFIED="1582232019311"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Commands to run following an unsuccessful build
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
</node>
<node TEXT="search" ID="ID_296892426" CREATED="1574050460344" MODIFIED="1574050472677"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Start a search REPL to find definitions matching names and types
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="path" ID="ID_1428122485" CREATED="1574050482114" MODIFIED="1582232122056"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Displays paths used in Spago
    </p>
    <p>
      (note: this is intended to be used by tools)
    </p>
  </body>
</html>

</richcontent>
<node TEXT="output" ID="ID_1138753733" CREATED="1582232088318" MODIFIED="1582232095552"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      prints the path used for the `purs` compiler's output
    </p>
    <p>
      (note: this is intended to be used by tools)
    </p>
  </body>
</html>

</richcontent>
</node>
</node>
<node TEXT="test" ID="ID_1637788611" CREATED="1551923377441" MODIFIED="1551924051141"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -m | --main ]" ID="ID_1013267461" CREATED="1551923958208" MODIFIED="1551923963892">
<node TEXT="MAIN" ID="ID_1837765278" CREATED="1551923964176" MODIFIED="1551924060408"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -c | --global-cache ]" ID="ID_630720175" CREATED="1551923492946" MODIFIED="1564497356522"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Configure global caching behavior
    </p>
  </body>
</html>
</richcontent>
<node TEXT="GLOBAL-CACHE" ID="ID_357645087" CREATED="1564497336734" MODIFIED="1564497351774"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      'skip' - don't use the global cache
    </p>
    <p>
      'update' - force an update to the global cache
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="[ -w | --watch]" ID="ID_1125038206" CREATED="1553221031133" MODIFIED="1553221045369"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -l | --clear-screen ]" ID="ID_1399466616" CREATED="1564497660209" MODIFIED="1564497680232"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Clear the screen on rebuild (watch mode only)
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -p | --path]" ID="ID_1929530097" CREATED="1551923849311" MODIFIED="1551923856188">
<node TEXT="PATH" ID="ID_1023096035" CREATED="1551923874911" MODIFIED="1551923883158"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -x | --source-maps ]" ID="ID_1592370697" CREATED="1582232519588" MODIFIED="1582232534915"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Whether to generate source maps for the bundle
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -n | --no-install ]" ID="ID_1496746199" CREATED="1564497682956" MODIFIED="1564497701903"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Don't run the automatic installation of packages
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -u | --purs-args ]" ID="ID_1492712136" CREATED="1574049739584" MODIFIED="1574049756158"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Argument to pass to `purs`
    </p>
  </body>
</html>
</richcontent>
<node TEXT="PURS-ARGS" ID="ID_1151786780" CREATED="1574049747177" MODIFIED="1574049750853"/>
</node>
<node TEXT="[ -d | --deps-only ]" ID="ID_32902423" CREATED="1564497542092" MODIFIED="1564497562833"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Only use sources from dependencies, skipping the project sources
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -S | --no-share-output ]" ID="ID_1366254256" CREATED="1574049845328" MODIFIED="1574049887731"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Disable using a shared output folder in location of root `packages.dhall` (e.g. when using monorepo)
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -b, --before ]" ID="ID_81370501" CREATED="1582231970165" MODIFIED="1582231977130">
<node TEXT="BEFORE" ID="ID_1447876651" CREATED="1582231977572" MODIFIED="1582232006697"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Commands to run before a build
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="[ -t, --then ]" ID="ID_354326776" CREATED="1582231983800" MODIFIED="1582231988468">
<node TEXT="THEN" ID="ID_645319527" CREATED="1582231988674" MODIFIED="1582232014318"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Commands to run following a successful build
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="[ -e, --else ]" ID="ID_390623617" CREATED="1582231992417" MODIFIED="1582231996529">
<node TEXT="ELSE" ID="ID_706715410" CREATED="1582231996823" MODIFIED="1582232019311"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Commands to run following an unsuccessful build
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="[ -a | --node-args ]" ID="ID_1155864343" CREATED="1564497794867" MODIFIED="1564497800528">
<node TEXT="NODE-ARGS" ID="ID_627038136" CREATED="1564497800793" MODIFIED="1564497815571"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Argument to pass to node (run/test only)
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
</node>
<node TEXT="run" ID="ID_836280870" CREATED="1551923377441" MODIFIED="1553221114130"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -m | --main ]" ID="ID_695808098" CREATED="1551923958208" MODIFIED="1551923963892">
<node TEXT="MAIN" ID="ID_235926539" CREATED="1551923964176" MODIFIED="1574049974389"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -c | --global-cache ]" ID="ID_389502387" CREATED="1551923492946" MODIFIED="1564497356522"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Configure global caching behavior
    </p>
  </body>
</html>
</richcontent>
<node TEXT="GLOBAL-CACHE" ID="ID_849238608" CREATED="1564497336734" MODIFIED="1564497351774"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      'skip' - don't use the global cache
    </p>
    <p>
      'update' - force an update to the global cache
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="[ -w | --watch]" ID="ID_1187094779" CREATED="1553221031133" MODIFIED="1553221045369"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -l | --clear-screen ]" ID="ID_804834687" CREATED="1564497660209" MODIFIED="1564497680232"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Clear the screen on rebuild (watch mode only)
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -p | --path]" ID="ID_11616127" CREATED="1551923849311" MODIFIED="1551923856188">
<node TEXT="PATH" ID="ID_1587286306" CREATED="1551923874911" MODIFIED="1551923883158"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -x | --source-maps ]" ID="ID_990415219" CREATED="1582232519588" MODIFIED="1582232534915"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Whether to generate source maps for the bundle
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -n | --no-install ]" ID="ID_652899366" CREATED="1564497682956" MODIFIED="1564497701903"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Don't run the automatic installation of packages
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -u | --purs-args ]" ID="ID_978190509" CREATED="1574049739584" MODIFIED="1574049756158"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Argument to pass to `purs`
    </p>
  </body>
</html>
</richcontent>
<node TEXT="PURS-ARGS" ID="ID_433039311" CREATED="1574049747177" MODIFIED="1574049750853"/>
</node>
<node TEXT="[ -d | --deps-only ]" ID="ID_351603056" CREATED="1564497542092" MODIFIED="1564497562833"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Only use sources from dependencies, skipping the project sources
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -S | --no-share-output ]" ID="ID_718018129" CREATED="1574049845328" MODIFIED="1574049887731"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Disable using a shared output folder in location of root `packages.dhall` (e.g. when using monorepo)
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -b, --before ]" ID="ID_1769903099" CREATED="1582231970165" MODIFIED="1582231977130">
<node TEXT="BEFORE" ID="ID_1365000087" CREATED="1582231977572" MODIFIED="1582232006697"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Commands to run before a build
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="[ -t, --then ]" ID="ID_1543374989" CREATED="1582231983800" MODIFIED="1582231988468">
<node TEXT="THEN" ID="ID_1341044149" CREATED="1582231988674" MODIFIED="1582232014318"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Commands to run following a successful build
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="[ -e, --else ]" ID="ID_28662972" CREATED="1582231992417" MODIFIED="1582231996529">
<node TEXT="ELSE" ID="ID_1552446312" CREATED="1582231996823" MODIFIED="1582232019311"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Commands to run following an unsuccessful build
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="[ -a | --node-args ]" ID="ID_1702555393" CREATED="1564497794867" MODIFIED="1564497800528">
<node TEXT="NODE-ARGS" ID="ID_1541213442" CREATED="1564497800793" MODIFIED="1564497815571"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Argument to pass to node (run/test only)
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
</node>
<node TEXT="bundle-app" ID="ID_1768499571" CREATED="1551923378169" MODIFIED="1558495662075"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -m | --main ]" ID="ID_648267555" CREATED="1551923958208" MODIFIED="1551923963892">
<node TEXT="MAIN" ID="ID_827849737" CREATED="1551923964176" MODIFIED="1558495716864"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Module with a `main :: Effect Unit` function,
    </p>
    <p>
      which is used as the application's entry point
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="[ -t | --to ]" ID="ID_664462634" CREATED="1551924016257" MODIFIED="1551924024566">
<node TEXT="TO" ID="ID_1751346589" CREATED="1551924025017" MODIFIED="1551924030373"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -s | --no-build ]" ID="ID_1638873225" CREATED="1553221309505" MODIFIED="1553221322616"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -c | --global-cache ]" ID="ID_1275633849" CREATED="1551923492946" MODIFIED="1564497356522"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Configure global caching behavior
    </p>
  </body>
</html>
</richcontent>
<node TEXT="GLOBAL-CACHE" ID="ID_248485409" CREATED="1564497336734" MODIFIED="1564497351774"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      'skip' - don't use the global cache
    </p>
    <p>
      'update' - force an update to the global cache
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="[ -w | --watch]" ID="ID_1294750668" CREATED="1553221031133" MODIFIED="1553221045369"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -l | --clear-screen ]" ID="ID_1134521516" CREATED="1564497660209" MODIFIED="1564497680232"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Clear the screen on rebuild (watch mode only)
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -p | --path]" ID="ID_1322249671" CREATED="1551923849311" MODIFIED="1551923856188">
<node TEXT="PATH" ID="ID_1223011119" CREATED="1551923874911" MODIFIED="1551923883158"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -x | --source-maps ]" ID="ID_832971704" CREATED="1582232519588" MODIFIED="1582232534915"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Whether to generate source maps for the bundle
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -n | --no-install ]" ID="ID_1947706408" CREATED="1564497682956" MODIFIED="1564497701903"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Don't run the automatic installation of packages
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -u | --purs-args ]" ID="ID_143676244" CREATED="1574049739584" MODIFIED="1574049756158"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Argument to pass to `purs`
    </p>
  </body>
</html>
</richcontent>
<node TEXT="PURS-ARGS" ID="ID_1596302851" CREATED="1574049747177" MODIFIED="1574049750853"/>
</node>
<node TEXT="[ -d | --deps-only ]" ID="ID_23143385" CREATED="1564497542092" MODIFIED="1564497562833"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Only use sources from dependencies, skipping the project sources
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -S | --no-share-output ]" ID="ID_1703092877" CREATED="1574049845328" MODIFIED="1574049887731"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Disable using a shared output folder in location of root `packages.dhall` (e.g. when using monorepo)
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -b, --before ]" ID="ID_290391602" CREATED="1582231970165" MODIFIED="1582231977130">
<node TEXT="BEFORE" ID="ID_110688964" CREATED="1582231977572" MODIFIED="1582232006697"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Commands to run before a build
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="[ -t, --then ]" ID="ID_716481856" CREATED="1582231983800" MODIFIED="1582231988468">
<node TEXT="THEN" ID="ID_517183588" CREATED="1582231988674" MODIFIED="1582232014318"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Commands to run following a successful build
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="[ -e, --else ]" ID="ID_885566893" CREATED="1582231992417" MODIFIED="1582231996529">
<node TEXT="ELSE" ID="ID_503335167" CREATED="1582231996823" MODIFIED="1582232019311"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Commands to run following an unsuccessful build
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
</node>
<node TEXT="bundle-module" ID="ID_1116076178" CREATED="1551923379385" MODIFIED="1564497953500"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -m | --main ]" ID="ID_423326003" CREATED="1551923958208" MODIFIED="1551923963892">
<node TEXT="MAIN" ID="ID_203835316" CREATED="1551923964176" MODIFIED="1558495761417"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Module which is used as the application's entry point
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="[ -t | --to ]" ID="ID_684079827" CREATED="1551924016257" MODIFIED="1551924024566">
<node TEXT="TO" ID="ID_1330531633" CREATED="1551924025017" MODIFIED="1551924030373"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -s | --no-build ]" ID="ID_1104463465" CREATED="1553221309505" MODIFIED="1553221322616"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -c | --global-cache ]" ID="ID_459481453" CREATED="1551923492946" MODIFIED="1564497356522"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Configure global caching behavior
    </p>
  </body>
</html>
</richcontent>
<node TEXT="GLOBAL-CACHE" ID="ID_1070765508" CREATED="1564497336734" MODIFIED="1564497351774"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      'skip' - don't use the global cache
    </p>
    <p>
      'update' - force an update to the global cache
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="[ -w | --watch]" ID="ID_1632194393" CREATED="1553221031133" MODIFIED="1553221045369"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -l | --clear-screen ]" ID="ID_1133238465" CREATED="1564497660209" MODIFIED="1564497680232"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Clear the screen on rebuild (watch mode only)
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -p | --path]" ID="ID_389252320" CREATED="1551923849311" MODIFIED="1551923856188">
<node TEXT="PATH" ID="ID_517108413" CREATED="1551923874911" MODIFIED="1551923883158"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -x | --source-maps ]" ID="ID_33656198" CREATED="1582232519588" MODIFIED="1582232534915"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Whether to generate source maps for the bundle
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -n | --no-install ]" ID="ID_786072937" CREATED="1564497682956" MODIFIED="1564497701903"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Don't run the automatic installation of packages
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -u | --purs-args ]" ID="ID_1483557086" CREATED="1574049739584" MODIFIED="1574049756158"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Argument to pass to `purs`
    </p>
  </body>
</html>
</richcontent>
<node TEXT="PURS-ARGS" ID="ID_1388005339" CREATED="1574049747177" MODIFIED="1574049750853"/>
</node>
<node TEXT="[ -d | --deps-only ]" ID="ID_1830596474" CREATED="1564497542092" MODIFIED="1564497562833"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Only use sources from dependencies, skipping the project sources
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -S | --no-share-output ]" ID="ID_1861787024" CREATED="1574049845328" MODIFIED="1574049887731"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Disable using a shared output folder in location of root `packages.dhall` (e.g. when using monorepo)
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[ -b, --before ]" ID="ID_661659966" CREATED="1582231970165" MODIFIED="1582231977130">
<node TEXT="BEFORE" ID="ID_1852611170" CREATED="1582231977572" MODIFIED="1582232006697"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Commands to run before a build
    </p>
  </body>
</html>

</richcontent>
</node>
</node>
<node TEXT="[ -t, --then ]" ID="ID_1418059641" CREATED="1582231983800" MODIFIED="1582231988468">
<node TEXT="THEN" ID="ID_800482788" CREATED="1582231988674" MODIFIED="1582232014318"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Commands to run following a successful build
    </p>
  </body>
</html>

</richcontent>
</node>
</node>
<node TEXT="[ -e, --else ]" ID="ID_511173450" CREATED="1582231992417" MODIFIED="1582231996529">
<node TEXT="ELSE" ID="ID_433305066" CREATED="1582231996823" MODIFIED="1582232019311"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Commands to run following an unsuccessful build
    </p>
  </body>
</html>

</richcontent>
</node>
</node>
</node>
</node>
<node TEXT="[Package commands]" ID="ID_1654432025" CREATED="1582231462832" MODIFIED="1582231646931">
<node TEXT="install" ID="ID_1040398705" CREATED="1551923368362" MODIFIED="1558495559218"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Install (download) all dependencies listed in `spago.dhall` file
    </p>
  </body>
</html>
</richcontent>
<node TEXT="[ -c | --global-cache ]" ID="ID_1684328488" CREATED="1551923492946" MODIFIED="1564497356522"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Configure global caching behavior
    </p>
  </body>
</html>
</richcontent>
<node TEXT="GLOBAL-CACHE" ID="ID_1445955722" CREATED="1564497336734" MODIFIED="1564497351774"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      'skip' - don't use the global cache
    </p>
    <p>
      'update' - force an update to the global cache
    </p>
  </body>
</html>
</richcontent>
<node TEXT="PACKAGE" ID="ID_977825331" CREATED="1551923551151" MODIFIED="1551923562409"><richcontent TYPE="DETAILS">

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
<node TEXT="ls" ID="ID_1071067427" CREATED="1582231425870" MODIFIED="1582231429363">
<node TEXT="packages" ID="ID_1412419349" CREATED="1551923370817" MODIFIED="1582231532966"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      List that packages available in your packages.dhall file
    </p>
    <p>
      (i.e. list the packages you can install)
    </p>
  </body>
</html>

</richcontent>
<node TEXT="[ -f | --filter ]" ID="ID_1832468081" CREATED="1551923629012" MODIFIED="1551923669418">
<node TEXT="FILTER" ID="ID_252236746" CREATED="1551923670373" MODIFIED="1551923695263"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -j | --json ]" ID="ID_886907503" CREATED="1564497365521" MODIFIED="1564497377491"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      produce JSON output
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="deps" ID="ID_1850828966" CREATED="1582231433201" MODIFIED="1582231580462"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      List the dependencies in the spago.dhall file
    </p>
  </body>
</html>

</richcontent>
<node TEXT="[ -j, --json ]" ID="ID_1202676320" CREATED="1582231584033" MODIFIED="1582231590785"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Output the result as JSON
    </p>
  </body>
</html>

</richcontent>
</node>
<node TEXT="[ -t, --transitive ]" ID="ID_546576804" CREATED="1582231591110" MODIFIED="1582231601657"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Include transitive dependencies
    </p>
  </body>
</html>

</richcontent>
</node>
</node>
</node>
</node>
<node TEXT="[Package set commands]" ID="ID_779906125" CREATED="1552093036357" MODIFIED="1558495605739">
<node TEXT="verify" ID="ID_1742203273" CREATED="1551923372697" MODIFIED="1551923749219"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -c | --global-cache ]" ID="ID_1331740784" CREATED="1551923492946" MODIFIED="1564497356522"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Configure global caching behavior
    </p>
  </body>
</html>
</richcontent>
<node TEXT="GLOBAL-CACHE" ID="ID_1173986312" CREATED="1564497336734" MODIFIED="1564497351774"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      'skip' - don't use the global cache
    </p>
    <p>
      'update' - force an update to the global cache
    </p>
  </body>
</html>
</richcontent>
<node TEXT="PACKAGE" ID="ID_155165646" CREATED="1551923551151" MODIFIED="1551923789673"><richcontent TYPE="DETAILS">

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
</node>
<node TEXT="verify-set" ID="ID_408942717" CREATED="1551923374153" MODIFIED="1551923823575"><richcontent TYPE="DETAILS">

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
<node TEXT="[ -c | --global-cache ]" ID="ID_1021518112" CREATED="1551923492946" MODIFIED="1564497356522"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Configure global caching behavior
    </p>
  </body>
</html>
</richcontent>
<node TEXT="GLOBAL-CACHE" ID="ID_610522253" CREATED="1564497336734" MODIFIED="1564497351774"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      'skip' - don't use the global cache
    </p>
    <p>
      'update' - force an update to the global cache
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="[ -M | --no-check-modules-unique ]" ID="ID_420172409" CREATED="1574049622959" MODIFIED="1574049644786"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Skip checking whether modules names are unique across all packages
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="upgrade-set" ID="ID_836162157" CREATED="1551923380937" MODIFIED="1564497455324"><richcontent TYPE="DETAILS">

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
<node TEXT="freeze" ID="ID_93262395" CREATED="1551923384593" MODIFIED="1574049674150"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Recompute the hashes for the package-set
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="[Publish commands]" ID="ID_914717219" CREATED="1582231768581" MODIFIED="1582231771875">
<node TEXT="login" ID="ID_991005509" CREATED="1582231772462" MODIFIED="1582231806868"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Save the GitHub token to the global cache - set it with SPAGO_GITHUB_TOKEN env variable
    </p>
  </body>
</html>

</richcontent>
</node>
<node TEXT="bump-version" ID="ID_1987991505" CREATED="1582231774068" MODIFIED="1582231790563"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Bump and tag a new version, and generate bower.json, in preparation for release.
    </p>
  </body>
</html>

</richcontent>
<node TEXT="" ID="ID_431795580" CREATED="1582231852175" MODIFIED="1582231852176">
<hook NAME="FirstGroupNode"/>
</node>
<node TEXT="[ -f, --no-dry-run ]" ID="ID_1760441769" CREATED="1582231827339" MODIFIED="1582231847611"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Actually perform side-effects. The default is to describe what would be done
    </p>
  </body>
</html>

</richcontent>
</node>
<node TEXT="" ID="ID_1236577187" CREATED="1582231852169" MODIFIED="1582231852174">
<hook NAME="SummaryNode"/>
<hook NAME="AlwaysUnfoldedNode"/>
<node TEXT="BUMP" ID="ID_1891257445" CREATED="1582231852177" MODIFIED="1582231879450"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      how to bump the version. Acceptable values are:
    </p>
    <p>
      major
    </p>
    <p>
      minor
    </p>
    <p>
      patch
    </p>
    <p>
      a version (e.g. 'v1.2.3')
    </p>
  </body>
</html>

</richcontent>
</node>
</node>
</node>
</node>
<node TEXT="[Other commands]" ID="ID_241915319" CREATED="1552093096477" MODIFIED="1558495610520">
<node TEXT="version" ID="ID_366100741" CREATED="1551923395002" MODIFIED="1551924228905"><richcontent TYPE="DETAILS">

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
</node>
</node>
</node>
</node>
</map>
