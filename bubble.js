const randy = []

for (let i = 0; i < 20; i++) randy.push(Math.floor(Math.random()*100))

const bubble = (arr) => {
	let done = false
	while(!done){
		let swapped = false;
		for (let i = 0; i < arr.length-1; i++){
			if(arr[i] > arr[i+1]){
				swapped = true;
				const tmp = arr[i]
 				arr[i] = arr[i+1]
				arr[i+1] = tmp
			}
		}
		done = !swapped
	}
}

bubble(randy)
console.log(randy)
