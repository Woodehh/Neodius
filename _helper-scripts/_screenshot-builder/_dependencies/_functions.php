<?php
	function parseStringsFile($file) {
		global $languageStrings;
		//https://stackoverflow.com/questions/1686143/regex-for-parsing-strings-files
		$r = file_get_contents($file);
		preg_match_all('~^\s*"((?:\\\\.|[^"])*)"[^"]+"((?:\\\\.|[^"])*)"~m',$r, $matches, PREG_SET_ORDER);
		$parsed = array();
		foreach($matches as $m)
		$parsed[$m[1]] = $m[2];
		$languageStrings = $parsed;
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
	
	function parseLanguageFiles() {
		
		$localizations = array();
		if (!file_exists(LOCALIZATION_DIR))
			die("Localization dir not found");
		
		$languages_dir = scandir(LOCALIZATION_DIR);
		$localizations = json_decode(file_get_contents(LOCALES),true);
		
		foreach ($languages_dir as $k=>$l) {
			//unset starting with dot
			if (substr($l,0,1) != ".") {
				
				$language_code = str_replace(".lproj","",$l);
				$language_name = $localizations[$language_code]['englishName'];
	
				$existingTypes = array();
				//is iphone screenshot set available:
				if (is_dir(sprintf("../%s/iPhone/",$language_name)))
					$existingTypes[] = "iPhone";
					
				//check if iPad is already available
				if (is_dir(sprintf("../%s/iPad/",$language_name)))
					$existingTypes[] = "iPad";			
				
				
				if (count($existingTypes) > 0)
					$addition = "(".implode(",", $existingTypes).")";
				else
					$addition = "";
				
				$languages[$language_code] = array(
					"nameLocalized"=>@$localizations[$language_code]['localizedName'],
					"nameEnglish"=>@$localizations[$language_code]['englishName'],
					"stringsDir"=>realpath(LOCALIZATION_DIR.$l."/")."/",
					"stringsFile"=>realpath(LOCALIZATION_DIR.$l."/Localizable.strings")
				);
			}	
		}

		return $languages;				
	}
	
	
	function loadDevices() {
		$json = json_decode(file_get_contents(DEVICES_FILE),true);
		if (json_last_error() == JSON_ERROR_NONE)
			return $json;
		return false;
	}
