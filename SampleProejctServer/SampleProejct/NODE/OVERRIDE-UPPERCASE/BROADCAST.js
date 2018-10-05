FOR_BOX((box) => {
	
	/**
	 * 게임메이커용 BROADCAST OVERRIDE
	 */
	OVERRIDE(box.BROADCAST, (origin) => {
	
		box.BROADCAST = METHOD({
	
			run : (params) => {
				//REQUIRED: params
				//REQUIRED: params.roomName
				//OPTIONAL: params.methodName
				//OPTIONAL: params.data
				//OPTIONAL: params.str
	
				let roomName = box.boxName + '/' + params.roomName;
				let methodName = params.methodName;
				let data = params.data;
				let str = params.str;
				
				if (str !== undefined) {
					
					LAUNCH_ROOM_SERVER.broadcast({
						roomName : roomName,
						str : str
					});
		
					if (CPU_CLUSTERING.broadcast !== undefined) {
		
						CPU_CLUSTERING.broadcast({
							methodName : '__LAUNCH_ROOM_SERVER__MESSAGE',
							data : {
								roomName : roomName,
								str : str
							}
						});
					}
		
					if (SERVER_CLUSTERING.broadcast !== undefined) {
		
						SERVER_CLUSTERING.broadcast({
							methodName : '__LAUNCH_ROOM_SERVER__MESSAGE',
							data : {
								roomName : roomName,
								str : str
							}
						});
					}
				}
				
				else {
					
					LAUNCH_ROOM_SERVER.broadcast({
						roomName : roomName,
						methodName : methodName,
						data : data
					});
		
					if (CPU_CLUSTERING.broadcast !== undefined) {
		
						CPU_CLUSTERING.broadcast({
							methodName : '__LAUNCH_ROOM_SERVER__MESSAGE',
							data : {
								roomName : roomName,
								methodName : methodName,
								data : data
							}
						});
					}
		
					if (SERVER_CLUSTERING.broadcast !== undefined) {
		
						SERVER_CLUSTERING.broadcast({
							methodName : '__LAUNCH_ROOM_SERVER__MESSAGE',
							data : {
								roomName : roomName,
								methodName : methodName,
								data : data
							}
						});
					}
				}
			}
		});
	});
});