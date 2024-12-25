const canvas = document.getElementById('cordicGraph');
const ctx = canvas.getContext('2d');

// Draw axes
function drawAxes() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    ctx.beginPath();
    ctx.moveTo(300, 0);
    ctx.lineTo(300, 400);
    ctx.moveTo(0, 200);
    ctx.lineTo(600, 200);
    ctx.strokeStyle = '#000';
    ctx.stroke();
}

async function visualizeCORDIC(x, y, iterations, delay) {
    drawAxes();
    for (let i = 0; i <= iterations; i++) {
        const res = await fetch(`/cordic?x=${x}&y=${y}&iterations=${i}`).then(res => res.json());
        const px = 300 + res.x * 50;
        const py = 200 - res.y * 50;

        ctx.beginPath();
        ctx.arc(px, py, 2, 0, Math.PI * 2);
        ctx.fillStyle = 'red';
        ctx.fill();

        await new Promise(resolve => setTimeout(resolve, delay));
    }
}

visualizeCORDIC(1, 0.5, 30, 2000); // Visualize with delay of 2 seconds
