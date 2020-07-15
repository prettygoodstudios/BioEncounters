const randy = []
for (let i = 0; i < 20; i++) randy.push(Math.floor(Math.random()*100))

const selection = (arr) => {
 for (let i = 0; i < arr.length; i++){
	let min = arr[i];
	let minIndex = i;
	for (let j = i; j < arr.length; j++){
		if (arr[j] < min) {
			minIndex = j
			min = arr[j]
		}
	}
	arr[minIndex] = arr[i]
	arr[i] = min
 }
}

selection(randy)
console.log(randy)
