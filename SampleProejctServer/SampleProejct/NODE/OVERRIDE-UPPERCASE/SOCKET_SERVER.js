/*
 * 게임메이커용 소켓 서버 OVERRIDE
 */
OVERRIDE(SOCKET_SERVER, (origin) => {
	
	global.SOCKET_SERVER = METHOD({
	
		run : (port, connectionListener) => {
			//REQUIRED: port
			//REQUIRED: connectionListener
			
			let net = require('net');
			
			let packData = (data) => {
		
				let result = COPY(data);
				
				EACH(result, (value, name) => {
					
					if (value instanceof Date === true) {
		
						// change to seconds integer.
						result[name + 'Seconds'] = INTEGER(value.getTime() / 1000);
					}
					
					else if (value instanceof RegExp === true) {
						delete result[name];
					}
		
					else if (CHECK_IS_DATA(value) === true) {
						result[name] = packData(value);
					}
		
					else if (CHECK_IS_ARRAY(value) === true) {
		
						EACH(value, (v, i) => {
		
							if (CHECK_IS_DATA(v) === true) {
								value[i] = packData(v);
							}
						});
					}
				});
		
				return result;
			},
	
			// server
			server = net.createServer((conn) => {
	
				let methodMap = {};
				let sendKey = 0;
				let receivedStr = '';
				
				let clientInfo;
					
				let on;
				let off;
				let send;
	
				let runMethods = (methodName, data, sendKey) => {
					
					try {
						
						let methods = methodMap[methodName];
	
						if (methods !== undefined) {
		
							EACH(methods, (method) => {
		
								// run method.
								method(data,
		
								// ret.
								(retData) => {
		
									if (sendKey !== undefined) {
		
										send({
											methodName : '__CALLBACK_' + sendKey,
											data : retData
										});
									}
								});
							});
						}
					}
					
					// if catch error
					catch(error) {
						SHOW_ERROR('SOCKET_SERVER', error.toString(), {
							methodName : methodName,
							data : data
						});
					}
				};
	
				// when receive data
				conn.on('data', (content) => {
					
					let index;
					
					receivedStr += content.toString();
	
					while (( index = receivedStr.indexOf('\r\n')) !== -1) {
	
						let str = receivedStr.substring(0, index);
						
						let params = PARSE_STR(str);
	
						if (params !== undefined) {
							runMethods(params.methodName, params.data, params.sendKey);
						}
	
						receivedStr = receivedStr.substring(index + 1);
					}
					
					clientInfo.lastRecieveTime = new Date();
				});
	
				// when disconnected
				conn.on('close', () => {
					
					runMethods('__DISCONNECTED');
					
					// free method map.
					methodMap = undefined;
				});
	
				// when error
				conn.on('error', (error) => {
					
					if (error.code !== 'ECONNRESET' && error.code !== 'EPIPE' && error.code !== 'ETIMEDOUT' && error.code !== 'ENETUNREACH' && error.code !== 'EHOSTUNREACH' && error.code !== 'ECONNREFUSED' && error.code !== 'EINVAL') {
						
						let errorMsg = error.toString();
						
						SHOW_ERROR('SOCKET_SERVER', errorMsg);
						
						runMethods('__ERROR', errorMsg);
					}
				});
	
				connectionListener(
	
				// client info
				clientInfo = {
					
					ip : conn.remoteAddress,
					
					connectTime : new Date()
				},
	
				// on.
				on = (methodName, method) => {
					//REQUIRED: methodName
					//REQUIRED: method
	
					let methods = methodMap[methodName];
	
					if (methods === undefined) {
						methods = methodMap[methodName] = [];
					}
	
					methods.push(method);
				},
	
				// off.
				off = (methodName, method) => {
					//REQUIRED: methodName
					//OPTIONAL: method
	
					let methods = methodMap[methodName];
	
					if (methods !== undefined) {
	
						if (method !== undefined) {
	
							REMOVE({
								array : methods,
								value : method
							});
	
						} else {
							delete methodMap[methodName];
						}
					}
				},
	
				// send to client.
				send = (methodNameOrParams, callback) => {
					//REQUIRED: methodNameOrParams
					//OPTIONAL: methodNameOrParams.methodName
					//OPTIONAL: methodNameOrParams.data
					//OPTIONAL: methodNameOrParams.str
					//OPTIONAL: callback
	
					let methodName;
					let data;
					let str;
					
					if (CHECK_IS_DATA(methodNameOrParams) !== true) {
						methodName = methodNameOrParams;
					} else {
						methodName = methodNameOrParams.methodName;
						data = methodNameOrParams.data;
						str = methodNameOrParams.str;
					}
					
					if (conn !== undefined && conn.writable === true) {
						
						if (str !== undefined) {
							conn.write(str + '\r\n');
						}
						
						else {
							
							if (CHECK_IS_DATA(data) === true) {
								data = packData(data);
							}
							
							conn.write(JSON.stringify({
								methodName : methodName,
								data : data,
								sendKey : sendKey
							}) + '\r\n');
						}
		
						if (callback !== undefined) {
							
							let callbackName = '__CALLBACK_' + sendKey;
		
							// on callback.
							on(callbackName, (data) => {
		
								// run callback.
								callback(data);
		
								// off callback.
								off(callbackName);
							});
						}
		
						sendKey += 1;
						
						clientInfo.lastSendTime = new Date();
					}
				},
	
				// disconnect.
				() => {
					if (conn !== undefined) {
						conn.end();
						conn = undefined;
					}
				});
			});
	
			// listen.
			server.listen(port);
	
			console.log('[SOCKET_SERVER (for GMS)] RUNNING SOCKET SERVER... (PORT:' + port + ')');
		}
	});
});
