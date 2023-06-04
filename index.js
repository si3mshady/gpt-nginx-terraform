import { process } from "./env.js"

const setupTextarea = document.getElementById('setup-textarea') 
const setupInputContainer = document.getElementById('setup-input-container')
const movieBossText = document.getElementById('movie-boss-text')



function setBotReply(prompt) {
    // const apiKey = "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"
    const apiKey = process.env.OPEN_API_KEY
    const apiUrl = "https://api.openai.com/v1/chat/completions"


    const requestOptions = {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${apiKey}`
        },
        body: JSON.stringify({
          model: 'gpt-3.5-turbo',
          messages: [{"role": "user", "content": `Generate a one-sentence movie pitch about ${prompt} `}],
          max_tokens: 30,
          temperature: 0.8
        })
      };
      
    fetch(apiUrl, requestOptions)
        .then(response => response.json())
        .then(data => {
          // Handle the response data
          console.log(data);
          movieBossText.innerText = data.choices[0].message.content

        })
        .catch(error => {
          // Handle any errors
          console.error(error);
        });
    
}



document.getElementById("send-btn").addEventListener("click", () => {
  if (setupTextarea.value) {
    setupInputContainer.innerHTML = `<img src="/images/loading.svg" class="loading" id="loading">`
    movieBossText.innerText = `Ok, just wait a second while my digital brain digests that...`
    setBotReply(setupTextarea.value)
  }

    // setBotReply(setupTextarea.value)

})