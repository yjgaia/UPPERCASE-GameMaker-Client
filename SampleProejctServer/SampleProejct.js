require(process.env.UPPERCASE_PATH + '/LOAD.js');

BOOT({
	CONFIG : {
		isDevMode : true,
		
		defaultBoxName : 'SampleProejct',
		
		webServerPort : 8888,
		socketServerPort : 8889
	},
	NODE_CONFIG : {
		// 테스트 목적이기 때문에 CPU 클러스터링 기능을 사용하지 않습니다.
		isNotUsingCPUClustering : true
	}
});
