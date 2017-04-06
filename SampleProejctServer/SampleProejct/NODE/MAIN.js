SampleProejct.MAIN = METHOD({

	run : (addRequestHandler) => {
		
		SampleProejct.ROOM('Sample', (clientInfo, on, off, send, broadcastExceptMe) => {
			console.log('Sample 룸에 접속하였습니다.')
			
			on('message', (data, ret) => {
				
			});
		});
		
		SampleProejct.ROOM('Sample2', (clientInfo, on, off, send, broadcastExceptMe) => {
			console.log('Sample2 룸에 접속하였습니다.')
		});
	}
});
