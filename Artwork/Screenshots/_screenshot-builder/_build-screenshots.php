<?php
	
	// change dir
	chdir(__DIR__);

	function clear() {
		system("clear");
	}
	
	function parseStringsFile($file) {
		//https://stackoverflow.com/questions/1686143/regex-for-parsing-strings-files
		$r = file_get_contents($file);
		preg_match_all('~^\s*"((?:\\\\.|[^"])*)"[^"]+"((?:\\\\.|[^"])*)"~m',$r, $matches, PREG_SET_ORDER);
		$parsed = array();
		foreach($matches as $m)
		$parsed[$m[1]] = $m[2];
		return $parsed;
	}
	
	function __($s) {
		global $languageStrings;
		if (array_key_exists($s, $languageStrings))
			return $languageStrings[$s];
		else
			return $s;
	}
	
	function getwatchFolderContents() {
		return glob(getenv("HOME")."/Desktop/*.png");
	}
	
	function askQuestionForScreenshot($q,$watchFolder) {
		global $c,$enterWhenReady;
		
		echo $c($q)->bold().$enterWhenReady;
		echo cli\input();
		$new_files = array_diff(getWatchFolderContents(),$watchFolder);
		
		if (count($new_files) == 0){
			echo $c("No new files found. Make sure you made a screenshot.\n\n")->white()->bg_red();	
			return askQuestionForScreenshot($q,$watchFolder);
		} else {
			return array_values($new_files);
		}
	}	
	
	function slugify($text) {
	  // replace non letter or digits by -
	  $text = preg_replace('~[^\pL\d]+~u', '-', $text);
	  // transliterate
	  $text = iconv('utf-8', 'us-ascii//TRANSLIT', $text);
	  // remove unwanted characters
	  $text = preg_replace('~[^-\w]+~', '', $text);
	  // trim
	  $text = trim($text, '-');
	  // remove duplicate -
	  $text = preg_replace('~-+~', '-', $text);
	  // lowercase
	  $text = strtolower($text);
	  if (empty($text)) {
	    return 'n-a';
	  }
	  return $text;
	}
	

	// get localized data
	define("LOCALIZATION_DIR", "../../../Neodius/Supporting Files/LocalizedData/");

	//load the required stuff
	require("vendor/autoload.php");
	
	use Colors\Color;
	$c = new Color();
	
	//load up the localizations:
	$localizations = json_decode(file_get_contents("./_dependencies/Localizations.json"),true);

	//load up the available languages:
	$languages_dir = scandir(LOCALIZATION_DIR);
	
	//new array for languages
	$languages = $menuItems = array();
	
	//loop languages
	foreach ($languages_dir as $k=>$l) {
		//unset starting with dot
		if (substr($l,0,1) != ".") {
			$language_code = str_replace(".lproj","",$l);

			$languages[$language_code] = array(
				"nameLocalized"=>@$localizations[$language_code]['localizedName'],
				"nameEnglish"=>@$localizations[$language_code]['englishName'],
				"stringsDir"=>realpath(LOCALIZATION_DIR.$l."/")."/",
				"stringsFile"=>realpath(LOCALIZATION_DIR.$l."/Localizable.strings")
			);
			
			$language_menu_items[$language_code] = @$localizations[$language_code]['englishName'];
		}
	}

	clear();
	
	$varHeader = "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n".
				 "%%%% Screenshot builder for Neodius %%%%%%%%%%\n".
				 "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n\n";
				 
	echo $varHeader."Pick which language to generate language-screenshot.md for:\n";	
	//get the menu option
	$language_selection = cli\menu($language_menu_items, null, 'Select item');
	
	//set the selected language
	$l = $languages[$language_selection];
	
	//parse the strings file
	$languageStrings = parseStringsFile($l['stringsFile']);

	//include the config after the language selection has been made :-)
	include("_dependencies/screenshots.config.php");
	
	
	
	echo "\n\nAre you screenshotting for iPhone or iPad?:\n";		
	$device_selection = cli\menu(array(
		"iPhone" => "iPhone",
		"iPad" => "iPad",		
	), "iPhone", 'Select item');

	clear();	
	
	echo $varHeader;
	
	$enterWhenReady = "\nPress enter when you're ready\n";

	echo $c(sprintf("1. Start up the Simulator for an ".(($device_selection == "iPhone") ? "iPhone 8 Plus" : "iPad pro 10.9 inch")." on the latest iOS and set the language to: %s.",$l['nameEnglish']))->bold().$enterWhenReady;
	echo cli\input();
	
	//ask the question if the language was set correctly
	echo $c(sprintf("2. Launch Neodius and make sure the language is: %s.",$l['nameEnglish']))->bold().$enterWhenReady;	
	echo cli\input();

	//collect files on the Desktop:
	$watchFolder = getWatchFolderContents();
	
	//set question numbering
	$i=3;
	
	//loop through the screenshot array
	foreach ($array_screenshots as $t=>$s) {
		//check for new files
		$new_files = askQuestionForScreenshot(sprintf("%s. Take a screenshot of \"%s\".",$i,$t),$watchFolder);
		
		//multiple files have been found. Let the user 
		//decide which file is correct
		if (count($new_files) > 1) {
			$fileSelection = array();
			foreach  ($new_files as $f) {
				$fileSelection[basename($f)] = $f;
			}
			
			//get the menu option
			$screenshot_file_name = cli\menu($fileSelection, null, $c("Multiple new screenshots found. Please select which is the \"{$t}\" screen")->white()->bg_red());
			$screenshot_file_path = $fileSelection[$screenshot_file_name];
			
		} else {
			$screenshot_file_path = $new_files[0];
		}
		
		//enrich the array with file path;		
		$array_screenshots[$t]['screenshot_file_path'] = $screenshot_file_path;

		//reset watchfolder
		$watchFolder = getWatchFolderContents();		
		$i++;
	}

	clear();

	echo $varHeader;
	
	$mainDir = sprintf("../%s/",$l['nameEnglish']);
	
	//try to make the language dir
	if (!file_exists($mainDir)) {
		if (!mkdir($mainDir))
			die($c(sprintf("Can't write folder: %s\n",$l['nameEnglish']))->white()->bg_red());
	} else {
		echo $c(sprintf("Folder: %s already exists\n\n",$mainDir))->white()->bg_red();
	}

	$deviceDir = $mainDir."/".$device_selection."/";
	if (!file_exists($deviceDir)) {
		if (!mkdir($deviceDir))
			die($c(sprintf("Can't write folder: %s\n",$l['nameEnglish']))->white()->bg_red());
	} else {
		//we found target directory, ask question if continue
		echo $c(sprintf("Folder: %s already exists\n\n",$deviceDir))->white()->bg_red();
		echo $c(sprintf("Target directory %s already exists. Are you sure you want to recreate these screenshots?\n\nControl-C to cancel operation or enter to continue...",$deviceDir));
		echo cli\input();

		//empty the dir:
		$files = glob($deviceDir.'/*'); // get all file names
		foreach($files as $file){ // iterate files
		  if(is_file($file))
		    unlink($file); // delete file
		}		
		
	}
	
	
	
	
	//build images:
	$screenshot_html_code = array();
	foreach ($array_screenshots as $s) {
		$screenshot_html_code[] = sprintf('<img src="%s" width="200" alt="%s">',$s['filename'],__($s['title']));
		copy($s['screenshot_file_path'], $deviceDir."/".$s['filename']);
	}
	
	//build readme.md
	$template_file = file_get_contents("./_dependencies/_template.md");
	$readme_markdown = str_replace("%nameEnglish%", $l['nameEnglish'], $template_file);
	$readme_markdown = str_replace("%nameLocalized%", $l['nameLocalized'], $readme_markdown);
	$readme_markdown = str_replace("%creditLine%", __("<Language> is translated by: <your (nick) name> (<e-mail>)"), $readme_markdown);	
	$readme_markdown = str_replace("%screenshots%", implode(" ", $screenshot_html_code)	, $readme_markdown);	

	file_put_contents($deviceDir."/".slugify($l['nameEnglish'])."-screenshots.md", $readme_markdown);

	clear();

	echo $varHeader;
	
	echo "Done!\n\n";
	