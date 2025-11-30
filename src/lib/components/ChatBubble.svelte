<script>
  export let msg;

  const isUser = msg.sender === "user";

  const themes = {
    user: {
      accent: "0 0 20px rgba(255,255,255,0.8)",
      glow: "0 0 35px rgba(255,255,255,0.7)"
    },
    シエル: {
      accent: "0 0 20px rgba(0,180,255,0.9)",
      glow: "0 0 35px rgba(0,180,255,0.7)"
    },
    ピオナ: {
      accent: "0 0 20px rgba(255,120,180,0.9)",
      glow: "0 0 35px rgba(255,120,180,0.7)"
    },
    ミュリィ: {
      accent: "0 0 20px rgba(120,255,200,0.9)",
      glow: "0 0 35px rgba(120,255,200,0.7)"
    }
  };

  const currentTheme = themes[msg.sender] || themes.user;
</script>

<div class="message-row {isUser ? 'right' : ''}">
  <img class="avatar" src={`/avatars/${msg.sender}.png`} alt={msg.sender} />

  <div class="content">
    <span class="name">{msg.sender}</span>

    <div class="bubble"
  style="
    box-shadow:
      0 0 12px {currentTheme.accent},
      0 0 24px {currentTheme.glow},
      inset 0 0 10px {currentTheme.accent};
  "
>

      <p class="text">{msg.text}</p>
    </div>
  </div>
</div>

<style>
.bubble {
  position: relative;
  background: rgba(0, 0, 0, 0.45);
  padding: 18px 22px;
  border-radius: 16px;
  margin-top: 4px;

  /* ←ここでサイバー感を復活 */
  border: 1px solid rgba(255, 255, 255, 0.15);
  backdrop-filter: blur(6px);
  box-shadow:
    0 0 12px rgba(0, 255, 255, 0.4),
    0 0 24px rgba(0, 255, 255, 0.25),
    inset 0 0 10px rgba(0, 255, 255, 0.1);

  /* アニメーションで光が揺らぐ */
  animation: pulseGlow 2.6s ease-in-out infinite;
}

@keyframes pulseGlow {
  0% {
    box-shadow:
      0 0 12px rgba(0, 255, 255, 0.4),
      0 0 24px rgba(0, 255, 255, 0.25),
      inset 0 0 10px rgba(0, 255, 255, 0.1);
  }
  50% {
    box-shadow:
      0 0 20px rgba(0, 255, 255, 0.75),
      0 0 40px rgba(0, 255, 255, 0.35),
      inset 0 0 16px rgba(0, 255, 255, 0.2);
  }
  100% {
    box-shadow:
      0 0 12px rgba(0, 255, 255, 0.4),
      0 0 24px rgba(0, 255, 255, 0.25),
      inset 0 0 10px rgba(0, 255, 255, 0.1);
  }
}

</style>
