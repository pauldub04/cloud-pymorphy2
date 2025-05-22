async function analyze() {
    console.log('analyze');
    const text = document.getElementById('wordInput').value;
    
    try {
        const response = await fetch('http://10.20.14.105/api/analyze', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                text: text
            })
        });
        
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        
        const result = await response.json();
        document.getElementById('result').innerHTML = JSON.stringify(result, null, 2);
    } catch (error) {
        console.error('Error:', error);
        document.getElementById('result').innerHTML = `Error: ${error.message}`;
    }
}