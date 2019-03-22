<map version="freeplane 1.6.0">
<!--To view this file, download free mind mapping software Freeplane from http://freeplane.sourceforge.net -->
<node TEXT="Purs" FOLDED="false" ID="ID_913272144" CREATED="1553220770647" MODIFIED="1553220810650" STYLE="oval">
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
<hook NAME="AutomaticEdgeColor" COUNTER="1" RULE="ON_BRANCH_CREATION"/>
<richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      PureScript Compiler
    </p>
  </body>
</html>

</richcontent>
<node TEXT="version 0.12.3" POSITION="right" ID="ID_651471323" CREATED="1534807447901" MODIFIED="1553220774040">
<edge COLOR="#ff0000"/>
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
<node TEXT="[--json-errors]" ID="ID_1658450750" CREATED="1534806300126" MODIFIED="1553221676314"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      Print errors to stderr as JSON
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
</node>
<node TEXT="--resolutions FILE" ID="ID_715463517" CREATED="1534806942547" MODIFIED="1553221799523"><richcontent TYPE="DETAILS">

<html>
  <head>
    
  </head>
  <body>
    <p>
      The resolutions file
    </p>
  </body>
</html>

</richcontent>
</node>
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
</map>
