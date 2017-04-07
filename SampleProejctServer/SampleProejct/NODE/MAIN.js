SampleProejct.MAIN = METHOD({

	run : (addRequestHandler) => {
		
		SampleProejct.ROOM('Sample', (clientInfo, on, off, send, broadcastExceptMe) => {
			console.log('Sample 룸에 접속하였습니다.');
			
			send({
				methodName : 'messageFromServer',
				data : {
					a : 1,
					b : 2,
					c : 3
				}
			});
			
			on('messageFromClient', (data, ret) => {
				console.log('메시지가 도착하였습니다.', data);
				ret(data);
			});
		});
		
		SampleProejct.ROOM('Sample2', (clientInfo, on, off, send, broadcastExceptMe) => {
			console.log('Sample2 룸에 접속하였습니다.');
		});
	}
});
