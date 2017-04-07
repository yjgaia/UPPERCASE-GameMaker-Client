require(process.env.UPPERCASE_PATH + '/LOAD.js');

BOOT({
	CONFIG : {
		isDevMode : true,
		
		defaultBoxName : 'SampleProejct',
		
		webServerPort : 8888,
		socketServerPort : 8889
	}
});
