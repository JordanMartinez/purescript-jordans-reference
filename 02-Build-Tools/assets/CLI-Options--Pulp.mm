<map version="freeplane 1.6.0">
<!--To view this file, download free mind mapping software Freeplane from http://freeplane.sourceforge.net -->
<node TEXT="Pulp" FOLDED="false" ID="ID_323827195" CREATED="1553220885289" MODIFIED="1553220891046" STYLE="oval">
<font SIZE="18"/>
<hook NAME="MapStyle">
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
<hook NAME="AutomaticEdgeColor" COUNTER="4" RULE="ON_BRANCH_CREATION"/>
<richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Build Tool
    </p>
  </body>
</html>

</richcontent>
<node TEXT="" POSITION="right" ID="ID_1618384151" CREATED="1534807536551" MODIFIED="1553220894897">
<hook NAME="FirstGroupNode"/>
<edge COLOR="#0000ff"/>
</node>
<node TEXT="12.3.0" POSITION="right" ID="ID_1304429576" CREATED="1534807520294" MODIFIED="1553220894898">
<edge COLOR="#00ff00"/>
</node>
<node TEXT="" POSITION="right" ID="ID_1563324897" CREATED="1534807536549" MODIFIED="1553220894976">
<hook NAME="SummaryNode"/>
<hook NAME="AlwaysUnfoldedNode"/>
<edge COLOR="#ff00ff"/>
<node TEXT="" ID="ID_1184654461" CREATED="1534807542511" MODIFIED="1534807542513">
<hook NAME="FirstGroupNode"/>
</node>
<node TEXT="[Global Options]" ID="ID_1238396046" CREATED="1534807536552" MODIFIED="1534807541863">
<node TEXT="(output)" ID="ID_187659511" CREATED="1534807826915" MODIFIED="1534807830813">
<node TEXT="--monochrome" ID="ID_1305097757" CREATED="1534807699693" MODIFIED="1534807708067"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      don't colorise log output
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="(pre/post processors)" ID="ID_1932450462" CREATED="1534807741695" MODIFIED="1534807773497">
<node TEXT="--before &lt;string&gt;" ID="ID_1331902356" CREATED="1534807544952" MODIFIED="1534807692295"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      run a shell command before the operation begins.
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="--then &lt;string&gt;" ID="ID_1394686660" CREATED="1534807593152" MODIFIED="1534807653793"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Run a shell command after operation finishes successfully
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="--else &lt;string&gt;" ID="ID_1263818984" CREATED="1534807583806" MODIFIED="1534807687104"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Run a shell command if an operation fails.
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
</node>
<node TEXT="(dependency manager)" ID="ID_1340424397" CREATED="1534807776781" MODIFIED="1534812984651">
<node TEXT="--psc-package" ID="ID_789488273" CREATED="1534807708925" MODIFIED="1534807717965"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      use psc-package for package management
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="-b|--bower-file &lt;file&gt;" ID="ID_746557360" CREATED="1534807783086" MODIFIED="1534808700166"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Read this specific bower.json file reading the one found via autodetection
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="(no args)" ID="ID_711470821" CREATED="1534812987983" MODIFIED="1534813031703"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Default to reading the auto-detected `bower.json` file
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="(fast feedback)" ID="ID_1309365421" CREATED="1534807846279" MODIFIED="1534807853636">
<node TEXT="-w|--watch" ID="ID_181236796" CREATED="1534807720725" MODIFIED="1534807733300"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Watch source directories and re-run command if something changes.
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="-v|--version" ID="ID_1550769909" CREATED="1534808755409" MODIFIED="1534808762808"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Show current pulp version
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="" ID="ID_1603607468" CREATED="1534807542510" MODIFIED="1534807542511">
<hook NAME="SummaryNode"/>
<hook NAME="AlwaysUnfoldedNode"/>
<node TEXT="[Commands]" ID="ID_820910018" CREATED="1534807542513" MODIFIED="1534812897502">
<node TEXT="(Many options are shared between multiple commands. Thus, they have been categorized and put here. The command will reference which group it supports.)" ID="ID_201756670" CREATED="1534810654840" MODIFIED="1534812667914" MAX_WIDTH="103.63635813894372 pt" MIN_WIDTH="103.63635813894372 pt">
<font BOLD="true"/>
<node TEXT="Output Path, Main, Check Main Type, No Check Main, No PSA options" ID="ID_916075524" CREATED="1534811064498" MODIFIED="1534812327837">
<node TEXT="[-o|--build-path &lt;string&gt;]" ID="ID_1910092878" CREATED="1534807913804" MODIFIED="1534808661767"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Path for compiler output.
    </p>
    <p>
      
    </p>
    <p>
      Default value: &quot;./output&quot;
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[--check-main-type &lt;string&gt;]" ID="ID_1236867171" CREATED="1534807926507" MODIFIED="1534808145684"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Specifyy an allowed list of types for an application's entry point (comma-separated list).
    </p>
    <p>
      
    </p>
    <p>
      Default value: &quot;Effect.Effect,Control.Monad.Eff.Eff&quot;
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[-m|--main &lt;string&gt;]" ID="ID_1359719274" CREATED="1534807971572" MODIFIED="1534808215458"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Module to be used as the application's entry point.
    </p>
    <p>
      
    </p>
    <p>
      Default value: &quot;Main&quot;
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[--no-check-main]" ID="ID_663057443" CREATED="1534807965280" MODIFIED="1534808226988"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Skip checking that the application has a suitable entry point
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[--no-psa]" ID="ID_1475897289" CREATED="1534807986753" MODIFIED="1534808246100"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Do not attempt to use the psa frontend instead of `purs compile`
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="Dependency Path option" ID="ID_1944400964" CREATED="1534811403016" MODIFIED="1534812268641">
<node TEXT="[--dependency-path &lt;dir&gt;]" ID="ID_868287226" CREATED="1534807931778" MODIFIED="1534808169007"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Directory for PureScript dependency files
    </p>
    <p>
      
    </p>
    <p>
      Defaule value: &quot;bower_components&quot;
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="Include additional directories option" ID="ID_392457215" CREATED="1534811428676" MODIFIED="1534812272407">
<node TEXT="[-I|-include &lt;dir:dir...&gt;]" ID="ID_1851896678" CREATED="1534807941022" MODIFIED="1534808190557"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Additional directories for PureScript source files, separated by ':'
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="Runtime option" ID="ID_1324211533" CREATED="1534811243291" MODIFIED="1534812338477">
<node TEXT="[-r|--runtime &lt;string&gt;]" ID="ID_139639652" CREATED="1534809184568" MODIFIED="1534809209356"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Run the program using the given command
    </p>
    <p>
      
    </p>
    <p>
      Default: &quot;node&quot;
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="Production options" ID="ID_584736778" CREATED="1534811026485" MODIFIED="1534811145332">
<node TEXT="[-O|--optimise]" ID="ID_1420986256" CREATED="1534807989753" MODIFIED="1534808254593"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Perform dead-code elimination
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[--skip-entry-point]" ID="ID_848919852" CREATED="1534808005142" MODIFIED="1534808295207"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Don't add code to automatically invoke Main
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[--source-maps]" ID="ID_1054193553" CREATED="1534808009731" MODIFIED="1534808301344"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Generate source maps
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[-t|--to &lt;string&gt;]" ID="ID_1679909178" CREATED="1534808028671" MODIFIED="1534808362099"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Name of output file (stdout if not specified)
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="Number of Cores options" ID="ID_1661617122" CREATED="1534811216280" MODIFIED="1534812239979">
<node TEXT="[-j|--jobs &lt;int&gt;]" ID="ID_1651188959" CREATED="1534807957074" MODIFIED="1534808202057"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Number of cores to use by `purs` command
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="Src &amp; Test Dir Location options" ID="ID_1807664587" CREATED="1534811154738" MODIFIED="1534812574804">
<node TEXT="[--src-path &lt;dir&gt;]" ID="ID_217731917" CREATED="1534808012477" MODIFIED="1534808498029"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Directory for PureScript source files
    </p>
    <p>
      
    </p>
    <p>
      Default: &quot;src&quot;
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[--test-path &lt;dir&gt;]" ID="ID_95215963" CREATED="1534808023599" MODIFIED="1534808338055"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Directory for PureScript test files
    </p>
    <p>
      
    </p>
    <p>
      Default: &quot;test&quot;
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
</node>
<node TEXT="" ID="ID_1101352190" CREATED="1534811577415" MODIFIED="1534811577416">
<hook NAME="FirstGroupNode"/>
</node>
<node TEXT="browserify" ID="ID_981295971" CREATED="1534807862473" MODIFIED="1534807902967"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Produce a deployable bundle using Browserify
    </p>
  </body>
</html>
</richcontent>
<node TEXT="(unique)" ID="ID_1084974110" CREATED="1534812028093" MODIFIED="1534812030553">
<node TEXT="[--force]" ID="ID_558681061" CREATED="1534807937058" MODIFIED="1534808177628"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Force a non-incremental build by deleting the build cache
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[--skip-compile]" ID="ID_1577140068" CREATED="1534808001047" MODIFIED="1534808286030"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Assume PureScript code has already been compiled.
    </p>
    <p>
      
    </p>
    <p>
      (Useful when want to pass options to `purs`
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[--standalone &lt;string&gt;]" ID="ID_763214558" CREATED="1534808017337" MODIFIED="1534808325526"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Output a UMD bundle with the given external module name
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[--transform &lt;string&gt;]" ID="ID_634606218" CREATED="1534808037350" MODIFIED="1534808387902"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Apply a Browserify transform
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="(shared)" ID="ID_1689618410" CREATED="1534812025000" MODIFIED="1534812026428">
<node TEXT="Output Path, Main, Check Main Type, No Check Main, No PSA options" ID="ID_1682274405" CREATED="1534811913627" MODIFIED="1534812358324"/>
<node TEXT="Dependency Path option" ID="ID_1008491031" CREATED="1534811403016" MODIFIED="1534812421542"/>
<node TEXT="Include additional directories option" ID="ID_945692888" CREATED="1534811420684" MODIFIED="1534812433340"/>
<node TEXT="Number of Cores options" ID="ID_319746797" CREATED="1534811439909" MODIFIED="1534813190527"/>
<node TEXT="Production options" ID="ID_338268906" CREATED="1534811469568" MODIFIED="1534812546954"/>
<node TEXT="Src &amp; Test Dir Location options" ID="ID_195568521" CREATED="1534811521214" MODIFIED="1534812529555"/>
</node>
</node>
<node TEXT="" ID="ID_124947898" CREATED="1534811577413" MODIFIED="1534811577415">
<hook NAME="SummaryNode"/>
<hook NAME="AlwaysUnfoldedNode"/>
<node TEXT="--" ID="ID_930684054" CREATED="1534808069457" MODIFIED="1534808072483">
<node TEXT="[passthrough options are sent to `purs bundle`]" ID="ID_199807334" CREATED="1534808060635" MODIFIED="1534808084979"/>
</node>
</node>
<node TEXT="" ID="ID_1487802956" CREATED="1534808506758" MODIFIED="1534808506758">
<hook NAME="FirstGroupNode"/>
</node>
<node TEXT="build" ID="ID_1291727394" CREATED="1534807864641" MODIFIED="1534808978351"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p style="margin-top: 0">
      Build the project
    </p>
  </body>
</html>
</richcontent>
<node TEXT="(unique)" ID="ID_58898277" CREATED="1534812039029" MODIFIED="1534812040841">
<node TEXT="[--modules &lt;string&gt;]" ID="ID_981369655" CREATED="1534808439890" MODIFIED="1534808456478"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Additional modules to be included in the output bundle (comma-separated list)
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="(shared)" ID="ID_1674481503" CREATED="1534812036461" MODIFIED="1534812038098">
<node TEXT="Output Path, Main, Check Main Type, No Check Main, No PSA options" ID="ID_604190573" CREATED="1534811913627" MODIFIED="1534812363443"/>
<node TEXT="Dependency Path option" ID="ID_1610635926" CREATED="1534811618538" MODIFIED="1534812419151"/>
<node TEXT="Include additional directories option" ID="ID_1461652274" CREATED="1534811631276" MODIFIED="1534812444216"/>
<node TEXT="Number of Cores options" ID="ID_1612603722" CREATED="1534811656112" MODIFIED="1534813198553"/>
<node TEXT="Production options" ID="ID_1628636560" CREATED="1534811676412" MODIFIED="1534812559671"/>
<node TEXT="Src &amp; Test Dir Location options" ID="ID_1186637517" CREATED="1534811690565" MODIFIED="1534812526552"/>
</node>
</node>
<node TEXT="" ID="ID_1172306217" CREATED="1534808506757" MODIFIED="1534808506758">
<hook NAME="SummaryNode"/>
<hook NAME="AlwaysUnfoldedNode"/>
<node TEXT="--" ID="ID_1730040275" CREATED="1534808506758" MODIFIED="1534808510337">
<node TEXT="[Passthrough options are sent to `purs compile`]" ID="ID_263616030" CREATED="1534808510588" MODIFIED="1534811772732"/>
</node>
</node>
<node TEXT="" ID="ID_452445506" CREATED="1534808791848" MODIFIED="1534808791849">
<hook NAME="FirstGroupNode"/>
</node>
<node TEXT="docs" ID="ID_1210809559" CREATED="1534807865916" MODIFIED="1534808992106" MAX_WIDTH="83.5472273076729 pt" MIN_WIDTH="83.5472273076729 pt"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Generate project documentation
    </p>
  </body>
</html>
</richcontent>
<node TEXT="(unique)" ID="ID_396343500" CREATED="1534812048517" MODIFIED="1534812050043">
<node TEXT="[-d|--with-dependencies]" ID="ID_611311426" CREATED="1534808626026" MODIFIED="1534808786440"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Include external dependencies
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[-t|--with-tests]" ID="ID_306606702" CREATED="1534808774730" MODIFIED="1534808782071"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Include tests
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="(shared)" ID="ID_1387955162" CREATED="1534812045869" MODIFIED="1534812047382">
<node TEXT="Dependency Path option" ID="ID_1490910468" CREATED="1534811740459" MODIFIED="1534812416026"/>
<node TEXT="Include additional directories option" ID="ID_1032583116" CREATED="1534811744034" MODIFIED="1534812451102"/>
<node TEXT="Src &amp; Test Dir Location options" ID="ID_1303043656" CREATED="1534811690565" MODIFIED="1534812521623"/>
</node>
</node>
<node TEXT="" ID="ID_1089785613" CREATED="1534808791846" MODIFIED="1534808791848">
<hook NAME="SummaryNode"/>
<hook NAME="AlwaysUnfoldedNode"/>
<node TEXT="--" ID="ID_486266414" CREATED="1534808791849" MODIFIED="1534808793240">
<node TEXT="[Passthrough options are sent to `purs docs`]" ID="ID_702695485" CREATED="1534808793416" MODIFIED="1534808801921"/>
</node>
</node>
<node TEXT="" ID="ID_1691764723" CREATED="1534808886515" MODIFIED="1534808886516">
<hook NAME="FirstGroupNode"/>
</node>
<node TEXT="init" ID="ID_175334739" CREATED="1534807866675" MODIFIED="1534808998116" MAX_WIDTH="71.61190910774911 pt" MIN_WIDTH="71.61190910774911 pt"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Generate an example PureScript project
    </p>
  </body>
</html>
</richcontent>
<node TEXT="--force" ID="ID_467418807" CREATED="1534808814658" MODIFIED="1534808828379"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Overwite any project found in current directory
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="--with-eff" ID="ID_1711953756" CREATED="1534808816390" MODIFIED="1534808876464"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Generate project using `Eff` (IO Monad <b>with </b>row effects), regardless of the detected compiler version
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="--with-effect" ID="ID_1998720037" CREATED="1534808818488" MODIFIED="1534808866010"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Generate project using `Eff` (IO Monad <b>without </b>row effects), regardless of the detected compiler version
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="" ID="ID_672112268" CREATED="1534808886514" MODIFIED="1534808886515">
<hook NAME="SummaryNode"/>
<hook NAME="AlwaysUnfoldedNode"/>
<node TEXT="--" ID="ID_52139344" CREATED="1534808892261" MODIFIED="1534808893569">
<node TEXT="[Passthrough options are ignored]" ID="ID_162739278" CREATED="1534808886516" MODIFIED="1534808890627"/>
</node>
</node>
<node TEXT="" ID="ID_829710370" CREATED="1534812681850" MODIFIED="1534812681852">
<hook NAME="FirstGroupNode"/>
</node>
<node TEXT="login" ID="ID_963738775" CREATED="1534807867386" MODIFIED="1534809005546" MAX_WIDTH="83.5472273076729 pt" MIN_WIDTH="83.5472273076729 pt"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Obtain and store a token for uploading packages to Pursuit
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="" ID="ID_1289189541" CREATED="1534812681845" MODIFIED="1534812681849">
<hook NAME="SummaryNode"/>
<hook NAME="AlwaysUnfoldedNode"/>
<node TEXT="--" ID="ID_1468618924" CREATED="1534812681852" MODIFIED="1534812683945">
<node TEXT="[Passthrough options are ignored]" ID="ID_1022628370" CREATED="1534808886516" MODIFIED="1534808890627"/>
</node>
</node>
<node TEXT="" ID="ID_1441676640" CREATED="1534809090565" MODIFIED="1534809090565">
<hook NAME="FirstGroupNode"/>
</node>
<node TEXT="publish" ID="ID_350793396" CREATED="1534807868353" MODIFIED="1534809037020" MAX_WIDTH="86.62730942378226 pt" MIN_WIDTH="86.62730942378226 pt"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Publish a previously tagged version to Bower and Pursuit
    </p>
  </body>
</html>
</richcontent>
<node TEXT="--no-push" ID="ID_555972774" CREATED="1534809039256" MODIFIED="1534809054056"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Skip pushing commits or tags to any remote
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="--push-to &lt;string&gt;" ID="ID_1291936539" CREATED="1534809054258" MODIFIED="1534809072750"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      The Git remote to which to push commits and tags to
    </p>
    <p>
      
    </p>
    <p>
      Default: &quot;origin&quot;
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="" ID="ID_380045793" CREATED="1534809090563" MODIFIED="1534809090565">
<hook NAME="SummaryNode"/>
<hook NAME="AlwaysUnfoldedNode"/>
<node TEXT="--" ID="ID_569203693" CREATED="1534808915967" MODIFIED="1534808917668">
<node TEXT="[Passthrough options are ignored]" ID="ID_694088204" CREATED="1534808886516" MODIFIED="1534808890627"/>
</node>
</node>
<node TEXT="" ID="ID_1104106594" CREATED="1534809144492" MODIFIED="1534809144493">
<hook NAME="FirstGroupNode"/>
</node>
<node TEXT="repl" ID="ID_1076989943" CREATED="1534807869507" MODIFIED="1534809130009" MAX_WIDTH="88.55236074635062 pt" MIN_WIDTH="88.55236074635062 pt"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Launch a PureScript REPL configured for the project
    </p>
  </body>
</html>
</richcontent>
<node TEXT="Dependency Path option" ID="ID_1154886142" CREATED="1534811824891" MODIFIED="1534812411771"/>
<node TEXT="Include additional directories option" ID="ID_20748393" CREATED="1534811829235" MODIFIED="1534812457658"/>
<node TEXT="Src &amp; Test Dir Location options" ID="ID_1465496562" CREATED="1534811836685" MODIFIED="1534812517761"/>
</node>
<node TEXT="" ID="ID_522488783" CREATED="1534809144491" MODIFIED="1534809144492">
<hook NAME="SummaryNode"/>
<hook NAME="AlwaysUnfoldedNode"/>
<node TEXT="--" ID="ID_789498117" CREATED="1534809144493" MODIFIED="1534809146047">
<node TEXT="[Passthrough options are sent to `purs repl`]" ID="ID_1842836797" CREATED="1534809146715" MODIFIED="1534809153742"/>
</node>
</node>
<node TEXT="" ID="ID_1535179762" CREATED="1534809260304" MODIFIED="1534809260305">
<hook NAME="FirstGroupNode"/>
</node>
<node TEXT="run" ID="ID_995638988" CREATED="1534807870261" MODIFIED="1534809183888" MAX_WIDTH="64.68172453009024 pt" MIN_WIDTH="64.68172453009024 pt"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Compile and run the project
    </p>
  </body>
</html>
</richcontent>
<node TEXT="Output Path, Main, Check Main Type, No Check Main, No PSA options" ID="ID_570956085" CREATED="1534811913627" MODIFIED="1534812369578"/>
<node TEXT="Dependency Path option" ID="ID_512815844" CREATED="1534811824891" MODIFIED="1534812408270"/>
<node TEXT="Include additional directories option" ID="ID_351620594" CREATED="1534811829235" MODIFIED="1534812459658"/>
<node TEXT="Number of Cores options" ID="ID_1553583962" CREATED="1534811872289" MODIFIED="1534813210923"/>
<node TEXT="Runtime option" ID="ID_58089331" CREATED="1534811893804" MODIFIED="1534811895450"/>
<node TEXT="Src &amp; Test Dir Location options" ID="ID_468948329" CREATED="1534811836685" MODIFIED="1534812508498"/>
</node>
<node TEXT="" ID="ID_506344896" CREATED="1534809260303" MODIFIED="1534809260304">
<hook NAME="SummaryNode"/>
<hook NAME="AlwaysUnfoldedNode"/>
<node TEXT="--" ID="ID_1740464145" CREATED="1534809260305" MODIFIED="1534809261691">
<node TEXT="[Passthrough options are sent to your program]" ID="ID_1102550519" CREATED="1534809261990" MODIFIED="1534809267752"/>
</node>
</node>
<node TEXT="" ID="ID_1998077429" CREATED="1534809422792" MODIFIED="1534809422793">
<hook NAME="FirstGroupNode"/>
</node>
<node TEXT="server" ID="ID_1784730455" CREATED="1534807871136" MODIFIED="1534809444250" MAX_WIDTH="78.1570837880687 pt" MIN_WIDTH="78.1570837880687 pt"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Launch a development server
    </p>
  </body>
</html>
</richcontent>
<node TEXT="(unique)" ID="ID_847192368" CREATED="1534811980555" MODIFIED="1534811982933">
<node TEXT="[--host &lt;string&gt;]" ID="ID_501394550" CREATED="1534809301763" MODIFIED="1534809320688"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      IP address to which to bind the server
    </p>
    <p>
      
    </p>
    <p>
      Default: &quot;localhost&quot;
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[-p|--port &lt;int&gt;]" ID="ID_623922418" CREATED="1534809340794" MODIFIED="1534809373883"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Port number on which to listen
    </p>
    <p>
      
    </p>
    <p>
      Default: 1337
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[-q|--quiet]" ID="ID_1451021800" CREATED="1534809376999" MODIFIED="1534809391544"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Display nothing to the console when rebuilding
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="(shared)" ID="ID_70792720" CREATED="1534811976905" MODIFIED="1534811978469">
<node TEXT="Output Path, Main, Check Main Type, No Check Main, No PSA options" ID="ID_181957589" CREATED="1534811944584" MODIFIED="1534812374471"/>
<node TEXT="Dependency Path option" ID="ID_1652204012" CREATED="1534811953863" MODIFIED="1534812405586"/>
<node TEXT="Include additional directories option" ID="ID_567319188" CREATED="1534811958260" MODIFIED="1534812463482"/>
<node TEXT="Src &amp; Test Dir Location options" ID="ID_890407342" CREATED="1534811967279" MODIFIED="1534812489628"/>
</node>
</node>
<node TEXT="" ID="ID_1249059427" CREATED="1534809422791" MODIFIED="1534809422792">
<hook NAME="SummaryNode"/>
<hook NAME="AlwaysUnfoldedNode"/>
<node TEXT="--" ID="ID_1317849401" CREATED="1534809422793" MODIFIED="1534809424851">
<node TEXT="[Passthrough options are ignored]" ID="ID_1126164382" CREATED="1534809425144" MODIFIED="1534809428674"/>
</node>
</node>
<node TEXT="" ID="ID_524988837" CREATED="1534809513631" MODIFIED="1534809513632">
<hook NAME="FirstGroupNode"/>
</node>
<node TEXT="test" ID="ID_17412336" CREATED="1534807872022" MODIFIED="1534807872619">
<node TEXT="Output Path, Main, Check Main Type, No Check Main, No PSA options" ID="ID_1427237821" CREATED="1534812133887" MODIFIED="1534812377559"/>
<node TEXT="Dependency Path option" ID="ID_758075867" CREATED="1534812139745" MODIFIED="1534812402482"/>
<node TEXT="Include additional directories option" ID="ID_201990978" CREATED="1534812144232" MODIFIED="1534812466276"/>
<node TEXT="Runtime option" ID="ID_1920150643" CREATED="1534812159569" MODIFIED="1534812162021"/>
<node TEXT="Src &amp; Test Dir Location options" ID="ID_1222755744" CREATED="1534812163375" MODIFIED="1534812501999"/>
</node>
<node TEXT="" ID="ID_755019506" CREATED="1534809513630" MODIFIED="1534809513631">
<hook NAME="SummaryNode"/>
<hook NAME="AlwaysUnfoldedNode"/>
<node TEXT="--" ID="ID_1218009525" CREATED="1534809513632" MODIFIED="1534809514896">
<node TEXT="[Passthrough options are sent to the test program]" ID="ID_1253815112" CREATED="1534809515275" MODIFIED="1534809540310"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      For example, when one only wants to run one particular test
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
</node>
<node TEXT="" ID="ID_1079432096" CREATED="1534809596064" MODIFIED="1534809596065">
<hook NAME="FirstGroupNode"/>
</node>
<node TEXT="version" ID="ID_1947914513" CREATED="1534807872783" MODIFIED="1534807874176">
<node TEXT="one of the following" ID="ID_1308989921" CREATED="1534812192086" MODIFIED="1534812195197">
<node TEXT="BUMP" ID="ID_240461888" CREATED="1534809562531" MODIFIED="1534812209278"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      where BUMP options are:
    </p>
    <p>
      - 'major'
    </p>
    <p>
      - 'minor'
    </p>
    <p>
      - 'patch'
    </p>
    <p>
      - &lt;specified version&gt;
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="(no arg)" ID="ID_794277737" CREATED="1534812196470" MODIFIED="1534812202774"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Pulp will prompt you for a version
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
</node>
<node TEXT="" ID="ID_822291448" CREATED="1534809596063" MODIFIED="1534809596064">
<hook NAME="SummaryNode"/>
<hook NAME="AlwaysUnfoldedNode"/>
<node TEXT="--" ID="ID_1870489499" CREATED="1534809596065" MODIFIED="1534809597677">
<node TEXT="[Passthrough options are ignored]" ID="ID_1241686519" CREATED="1534809597881" MODIFIED="1534809602053"/>
</node>
</node>
</node>
</node>
</node>
</node>
</map>
