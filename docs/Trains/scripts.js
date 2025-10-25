const players = {};
let isMuted = true;
let isPaused = false;
let readyCount = 0;

function generateVideoGrid() {
    const videoGrid = document.getElementById('videoGrid');
    videoIds.forEach((vid, index) => {
        const container = document.createElement('div');
        container.className = 'video-container';

        const iframe = document.createElement('iframe');
        iframe.id = `player${index + 1}`;
        iframe.src = `https://www.youtube.com/embed/${vid}?enablejsapi=1&autoplay=1&mute=1`;
        iframe.allow = 'autoplay';
        iframe.allowFullscreen = true;

        container.appendChild(iframe);
        videoGrid.appendChild(container);
    });
}

function initializeYouTubePlayers() {
    videoIds.forEach((vid, i) => {
        const id = `player${i + 1}`;
        players[id] = new YT.Player(id, {
            events: {
                onReady: () => {
                    readyCount++;
                    if (readyCount === videoIds.length) {
                        enableControls();
                    }
                }
            }
        });
    });
}

function enableControls() {
    document.getElementById('toggleMuteBtn').addEventListener('click', toggleMuteAll);
    document.getElementById('togglePlayBtn').addEventListener('click', togglePlayAll);
    document.getElementById('liveAllBtn').addEventListener('click', seekToLiveAll);
}

function toggleMuteAll() {
    Object.values(players).forEach(player => {
        if (player && typeof player.unMute === 'function' && typeof player.mute === 'function') {
            isMuted ? player.unMute() : player.mute();
        }
    });

    isMuted = !isMuted;
    const btn = document.getElementById('toggleMuteBtn');
    btn.textContent = isMuted ? 'Unmute All' : 'Mute All';
    btn.style.color = isMuted ? 'red' : '#006400';
    btn.style.borderColor = isMuted ? 'red' : '#006400';
}

function togglePlayAll() {
    Object.values(players).forEach(player => {
        if (player && typeof player.pauseVideo === 'function' && typeof player.playVideo === 'function') {
            isPaused ? player.playVideo() : player.pauseVideo();
        }
    });

    isPaused = !isPaused;
    const btn = document.getElementById('togglePlayBtn');
    btn.textContent = isPaused ? 'Play All' : 'Pause All';
    btn.style.color = isPaused ? 'red' : '#006400';
    btn.style.borderColor = isPaused ? 'red' : '#006400';
}

function seekToLiveAll() {
    Object.values(players).forEach(player => {
        if (player && typeof player.getDuration === 'function' && typeof player.seekTo === 'function') {
            const duration = player.getDuration();
            player.seekTo(duration - 1, true);
        }
    });
}

function onYouTubeIframeAPIReady() {
    initializeYouTubePlayers();
}

function exposeGlobals() {
    window.generateVideoGrid = generateVideoGrid;
    window.toggleMuteAll = toggleMuteAll;
    window.togglePlayAll = togglePlayAll;
    window.seekToLiveAll = seekToLiveAll;
    window.onYouTubeIframeAPIReady = onYouTubeIframeAPIReady;
}

exposeGlobals();
