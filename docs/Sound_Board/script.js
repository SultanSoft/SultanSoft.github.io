document.addEventListener('DOMContentLoaded', () => {
    // Select all buttons whose ID starts with 'playButton_'
    const playButtons = document.querySelectorAll('[id^="playButton_"]');

    playButtons.forEach(button => {
        button.addEventListener('click', () => {
            // Extract the base filename from the button's ID
            // e.g., 'playButton_filename.mp3' -> 'filename.mp3'
            const filename = button.id.replace('playButton_', '');
            const audioId = `audio_${filename}`;
            const audio = document.getElementById(audioId);

            if (audio) {
                // Stop and reset if already playing
                audio.pause();
                audio.currentTime = 0;
                audio.play();
            }
        });
    });
});