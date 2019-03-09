<map version="freeplane 1.6.0">
<!--To view this file, download free mind mapping software Freeplane from http://freeplane.sourceforge.net -->
<node TEXT="Purescript Build Tools" FOLDED="false" ID="ID_61115281" CREATED="1534805902352" MODIFIED="1534805907447" STYLE="oval">
<font SIZE="18"/>
<hook NAME="MapStyle" zoom="1.103">
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
<hook NAME="AutomaticEdgeColor" COUNTER="14" RULE="ON_BRANCH_CREATION"/>
<node TEXT="Compiler" POSITION="right" ID="ID_410651686" CREATED="1534812873191" MODIFIED="1534812875456">
<edge COLOR="#ff0000"/>
<node TEXT="purs" ID="ID_1194666949" CREATED="1534805908350" MODIFIED="1534812873256">
<node TEXT="version 0.12.0" ID="ID_651471323" CREATED="1534807447901" MODIFIED="1534807451226">
<node TEXT="--version" ID="ID_197565909" CREATED="1534805941994" MODIFIED="1534805946282"/>
<node TEXT="-h, --help" ID="ID_1937065219" CREATED="1534805946874" MODIFIED="1534805957411"/>
<node TEXT="commands" ID="ID_480442587" CREATED="1534805991729" MODIFIED="1534805993274">
<node TEXT="bundle" ID="ID_1616447521" CREATED="1534805958055" MODIFIED="1534806221674" MAX_WIDTH="108.95790494916236 pt" MIN_WIDTH="108.95790494916236 pt"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Bundle compiled PureScript modules for the browser
    </p>
  </body>
</html>
</richcontent>
<node TEXT="FILE" ID="ID_1379265469" CREATED="1534806010982" MODIFIED="1534806164541"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      the input .js file(s)
    </p>
  </body>
</html>
</richcontent>
<node TEXT="[-o|--output ARG]" ID="ID_1270047589" CREATED="1534806024423" MODIFIED="1534807171067"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      the output .js file
    </p>
  </body>
</html>
</richcontent>
<node TEXT="[--source-maps]" ID="ID_1213415719" CREATED="1534806049817" MODIFIED="1534807188517"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      whether to generate source maps for the bundle (requires --output)
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="[-m|--module ARG]" ID="ID_455957672" CREATED="1534806035346" MODIFIED="1534807174124"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Entry point module name(s).
    </p>
    <p>
      
    </p>
    <p>
      All code which is not a transitive dependency of an entry point module will be removed
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[--main ARG]" ID="ID_1833424874" CREATED="1534806040336" MODIFIED="1534807177186"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Generate code to run the main method in the specified module
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[-n|--namespace ARG]" ID="ID_1113242274" CREATED="1534806045038" MODIFIED="1534807179786"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Specify the namespace to which PureScript modules will be exported when in the browser.
    </p>
    <p>
      
    </p>
    <p>
      Default: &quot;PS&quot;
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
</node>
<node TEXT="compile" ID="ID_1274999132" CREATED="1534805959498" MODIFIED="1534806246390" MAX_WIDTH="107.80287415562132 pt" MIN_WIDTH="107.80287415562132 pt"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Compile PureScript source files
    </p>
  </body>
</html>
</richcontent>
<node TEXT="[FILE]" ID="ID_630179378" CREATED="1534806257995" MODIFIED="1534807207893"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      the input .purs file(s)
    </p>
  </body>
</html>
</richcontent>
<node TEXT="[-o|--output ARG]" ID="ID_451418455" CREATED="1534806274681" MODIFIED="1534807220653"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      The output directory
    </p>
    <p>
      
    </p>
    <p>
      Default value: &quot;output&quot;
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[-v|--verbose-errors]" ID="ID_284760818" CREATED="1534806280981" MODIFIED="1534807223076"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Display verbose error messages
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[-c|--comments]" ID="ID_66994993" CREATED="1534806285400" MODIFIED="1534807225038"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Include comments in the generated code
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[-g|--codegen ARG]" ID="ID_166841621" CREATED="1534806290389" MODIFIED="1534807227058"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Specifies comma-separated codegen targets to include.
    </p>
    <p>
      
    </p>
    <p>
      Accepted targets:
    </p>
    <p>
      - 'corefn'
    </p>
    <p>
      - 'js' (if this option is used, only the specified targets will be used)
    </p>
    <p>
      - 'sourcemaps'
    </p>
    <p>
      
    </p>
    <p>
      Default target: 'js'
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[-p|--no-prefix]" ID="ID_1919275538" CREATED="1534806295014" MODIFIED="1534807229249"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Do not include comment header
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[--json-errors]" ID="ID_1658450750" CREATED="1534806300126" MODIFIED="1534807231288"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Print erros to stderr as JSON
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
</node>
<node TEXT="" ID="ID_259588547" CREATED="1534806666553" MODIFIED="1534806666553">
<hook NAME="FirstGroupNode"/>
</node>
<node TEXT="docs" ID="ID_420628804" CREATED="1534805960471" MODIFIED="1534806627282" MAX_WIDTH="108.57289450106147 pt" MIN_WIDTH="108.57289450106147 pt"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Generate documenation from PureScript source files in a variety of formats
    </p>
  </body>
</html>
</richcontent>
<node TEXT="[--format FORMAT]" ID="ID_612963931" CREATED="1534806459277" MODIFIED="1534807285069"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Set output FORMAT
    </p>
    <p>
      
    </p>
    <p>
      Options:
    </p>
    <p>
      - markdown
    </p>
    <p>
      - HTML
    </p>
    <p>
      - etags
    </p>
    <p>
      - ctags
    </p>
  </body>
</html>
</richcontent>
<node TEXT="[FILE]" ID="ID_479153258" CREATED="1534806471647" MODIFIED="1534807293383"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      The input .purs file(s)
    </p>
  </body>
</html>
</richcontent>
<node TEXT="[--docgen ARG]" ID="ID_1324116931" CREATED="1534806546068" MODIFIED="1534807295909"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      A list of module names which should appear in the output.
    </p>
    <p>
      
    </p>
    <p>
      This can optionally include file paths to which to write individual modules, by separating with a colon (':').
    </p>
    <p>
      
    </p>
    <p>
      For example, &quot;Prelude:docs/Prelude.md'. This option may be specified multiple times
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
</node>
</node>
<node TEXT="" ID="ID_29500556" CREATED="1534806666552" MODIFIED="1534806666553">
<hook NAME="SummaryNode"/>
<hook NAME="AlwaysUnfoldedNode"/>
<node TEXT="Examples" ID="ID_697502682" CREATED="1534806666553" MODIFIED="1534806669195">
<node TEXT="purs docs &quot;src/**/*.purs&quot; &quot;.psc-package/*/*/*/src/**/*.purs&quot; \&#xa;  --docgen Data.List:docs/Data.List.md \&#xa;  --docgen Data.List.Lazy:docs/Data.List.Lazy.md" ID="ID_711021409" CREATED="1534806670260" MODIFIED="1534806722712" MAX_WIDTH="297.2279242963472 pt" MIN_WIDTH="297.2279242963472 pt"/>
</node>
</node>
<node TEXT="hierarchy" ID="ID_1630926827" CREATED="1534805961845" MODIFIED="1534807314108" MAX_WIDTH="123.20328473616816 pt" MIN_WIDTH="123.20328473616816 pt"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Generate a GraphViz directed graph of Purecript Type Classes
    </p>
  </body>
</html>
</richcontent>
<node TEXT="[FILE]" ID="ID_1434530557" CREATED="1534806744259" MODIFIED="1534807322067"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      the input file to generate a hierarchy
    </p>
  </body>
</html>
</richcontent>
<node TEXT="[-o|--output ARG]" ID="ID_856960479" CREATED="1534806752082" MODIFIED="1534807324470"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      The output directory
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
</node>
<node TEXT="ide" ID="ID_1830792117" CREATED="1534805963708" MODIFIED="1534807403018" MAX_WIDTH="105.10780230402565 pt" MIN_WIDTH="105.10780230402565 pt"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      start or query an IDE server process
    </p>
  </body>
</html>
</richcontent>
<node TEXT="server" ID="ID_1464254713" CREATED="1534806790357" MODIFIED="1534806805932"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Start a server process
    </p>
  </body>
</html>
</richcontent>
<node TEXT="[-d|--directory ARG]" ID="ID_691105537" CREATED="1534806832525" MODIFIED="1534806838726"/>
<node TEXT="[Source GLOBS...]" ID="ID_188708337" CREATED="1534806839252" MODIFIED="1534806844294"/>
<node TEXT="[--output-directory ARG]" ID="ID_1624734280" CREATED="1534806844781" MODIFIED="1534806848922"/>
<node TEXT="[-p|--port ARG]" ID="ID_326853977" CREATED="1534806849424" MODIFIED="1534806854413"/>
<node TEXT="[--no-watch]" ID="ID_832972603" CREATED="1534806854603" MODIFIED="1534806858519"/>
<node TEXT="[--polling]" ID="ID_1404063374" CREATED="1534806858826" MODIFIED="1534806861607"/>
<node TEXT="[--log-level ARG]" ID="ID_1385077117" CREATED="1534806861808" MODIFIED="1534806897861"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      ARG can be:
    </p>
    <p>
      - &quot;debug&quot;
    </p>
    <p>
      - &quot;perf&quot;
    </p>
    <p>
      - &quot;all&quot;
    </p>
    <p>
      - &quot;none&quot;
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="[--editor-mode]" ID="ID_1266087837" CREATED="1534806866507" MODIFIED="1534806871004"/>
</node>
<node TEXT="client" ID="ID_193837392" CREATED="1534806806062" MODIFIED="1534806813584"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Connect to a running server
    </p>
  </body>
</html>
</richcontent>
<node TEXT="[-p|--port ARG]" ID="ID_1473278408" CREATED="1534806916246" MODIFIED="1534806922252"/>
</node>
</node>
<node TEXT="publish" ID="ID_1436728572" CREATED="1534805965244" MODIFIED="1534806992213" MAX_WIDTH="95.86755577211035 pt" MIN_WIDTH="95.86755577211035 pt"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Generates documentation packages for upload to Pursuit
    </p>
  </body>
</html>
</richcontent>
<node TEXT="--manifest FILE" ID="ID_1568468039" CREATED="1534806935229" MODIFIED="1534806967078"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      The package manifest file
    </p>
  </body>
</html>
</richcontent>
<node TEXT="--resolutions FILE" ID="ID_715463517" CREATED="1534806942547" MODIFIED="1534806970825"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      The resolutiosn file
    </p>
  </body>
</html>
</richcontent>
<node TEXT="[--dry-run]" ID="ID_1375760927" CREATED="1534806946300" MODIFIED="1534806979764"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Produce no output, and don' require a tagged version to be checked out
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
</node>
</node>
<node TEXT="repl" ID="ID_1902594740" CREATED="1534805966360" MODIFIED="1534807397986" MAX_WIDTH="72.76693990129013 pt" MIN_WIDTH="72.76693990129013 pt"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Enter the interactive mode (PSCi)
    </p>
  </body>
</html>
</richcontent>
<node TEXT="[FILES]" ID="ID_1449087626" CREATED="1534807000802" MODIFIED="1534807087306"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Optional .purs files to load on start
    </p>
  </body>
</html>
</richcontent>
<node TEXT="One of the following" ID="ID_1615790523" CREATED="1534807005397" MODIFIED="1534807018724">
<node TEXT="-p|--port ARG" ID="ID_257959462" CREATED="1534807019195" MODIFIED="1534807373079"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      The web server port
    </p>
  </body>
</html>
</richcontent>
</node>
<node TEXT="--node-path FILE" ID="ID_833550514" CREATED="1534807026978" MODIFIED="1534807371046"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Path to Node executable
    </p>
  </body>
</html>
</richcontent>
<node TEXT="[--node-opts OPTS]" ID="ID_1124360381" CREATED="1534807063749" MODIFIED="1534807124430"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Flags to pass to Node, separated by spaces
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
<node TEXT="(no args)" ID="ID_1428898083" CREATED="1534807038514" MODIFIED="1534812746566"/>
</node>
</node>
</node>
</node>
</node>
</node>
</node>
<node TEXT="Build Tool &amp;&#xa;Dependency Manager" POSITION="right" ID="ID_511624564" CREATED="1534812859688" MODIFIED="1552092153233">
<edge COLOR="#007c7c"/>
<node TEXT="spago" ID="ID_1828135657" CREATED="1551923344241" MODIFIED="1551923355883"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      (&quot;unofficial&quot; package manager)
    </p>
  </body>
</html>
</richcontent>
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
</node>
<node TEXT="(commands related to common workflow usage)" ID="ID_696549414" CREATED="1552093055189" MODIFIED="1552093064243">
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
<node TEXT="--" ID="ID_1001660261" CREATED="1551923937035" MODIFIED="1551923938701">
<node TEXT="[any &apos;purs&apos; options]" ID="ID_1845747807" CREATED="1551923890896" MODIFIED="1551923898094"/>
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
<node TEXT="[ -p | --path]" ID="ID_967318491" CREATED="1551923849311" MODIFIED="1551923856188">
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
<node TEXT="" ID="ID_257320090" CREATED="1551923886183" MODIFIED="1551923886184">
<hook NAME="SummaryNode"/>
<hook NAME="AlwaysUnfoldedNode"/>
<node TEXT="--" ID="ID_1215626806" CREATED="1551923886185" MODIFIED="1551923890524">
<node TEXT="[any &apos;purs&apos; options]" ID="ID_105848326" CREATED="1551923890896" MODIFIED="1551923898094"/>
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
<node TEXT="" ID="ID_1545637832" CREATED="1551923986401" MODIFIED="1551923986402">
<hook NAME="SummaryNode"/>
<hook NAME="AlwaysUnfoldedNode"/>
<node TEXT="--" ID="ID_519096311" CREATED="1551923986403" MODIFIED="1551923988108">
<node TEXT="[any &apos;purs&apos; options]" ID="ID_776246390" CREATED="1551923996105" MODIFIED="1551924002645"/>
</node>
</node>
</node>
<node TEXT="bundle" ID="ID_708362753" CREATED="1551923378169" MODIFIED="1551924080357"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Bundle the project
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
<node TEXT="Build Tool" POSITION="right" ID="ID_1475387471" CREATED="1534812867721" MODIFIED="1534812871948">
<edge COLOR="#7c7c00"/>
<node TEXT="pulp" ID="ID_702424329" CREATED="1534807467044" MODIFIED="1534812867831">
<node TEXT="" ID="ID_1618384151" CREATED="1534807536551" MODIFIED="1534807536552">
<hook NAME="FirstGroupNode"/>
</node>
<node TEXT="12.3.0" ID="ID_1304429576" CREATED="1534807520294" MODIFIED="1534807525266"/>
<node TEXT="" ID="ID_1563324897" CREATED="1534807536549" MODIFIED="1534807536551">
<hook NAME="SummaryNode"/>
<hook NAME="AlwaysUnfoldedNode"/>
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
</node>
<node TEXT="Dependency Manager" POSITION="right" ID="ID_773255504" CREATED="1552092143899" MODIFIED="1552092146869">
<edge COLOR="#00ff00"/>
<node TEXT="bower" ID="ID_13632247" CREATED="1534810623688" MODIFIED="1552092143914"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      (&quot;official&quot; package manager)
    </p>
  </body>
</html>
</richcontent>
</node>
</node>
</node>
</map>
