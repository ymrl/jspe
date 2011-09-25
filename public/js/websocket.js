(function(){
	ws = new WebSocket('ws://'+location.hostname+':3080')
	ws.addEventListener('message',function(e){
		try{ws.log(eval(e.data));}catch(err){ws.log(err.toLocaleString());}
	})
	ws.log = function(mes){
		if(mes instanceof HTMLElement){
			ws.send(mes.outerHTML);
		}else if(mes instanceof Object){
			try{ws.send(JSON.stringify(mes));}catch(err){ws.send(mes.toString());}
		}else{
			ws.send(mes);
		}
	}
})()
