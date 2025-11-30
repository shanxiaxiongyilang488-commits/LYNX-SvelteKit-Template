<script lang="ts">
  import ChatBubble from "$lib/components/ChatBubble.svelte";
  import { messages, addMessage, sendAIMessage } from "$lib/stores/chat";
  import { onMount, onDestroy } from "svelte";

  // 入力
  let input: string = "";

  // メッセージ一覧（購読用）
  let messageList = [];
  let scrollArea: HTMLDivElement;

  // ------------------------------
  // メッセージストア購読
  // ------------------------------
  const unsubscribe = messages.subscribe((v) => {
    messageList = v;

    // 描画後にスクロールを最下部へ
    setTimeout(() => {
      if (scrollArea) {
        scrollArea.scrollTop = scrollArea.scrollHeight;
      }
    }, 20);
  });

  onDestroy(unsubscribe);

  // ------------------------------
  // 送信処理
  // ------------------------------
  async function send() {
    if (!input.trim()) return;

    // 自分の発言
    addMessage("user", input);

    // AIへ（ダミー）
    await sendAIMessage(input);

    input = "";
  }
</script>

<!-- ======================= -->
<!--   マークアップ           -->
<!-- ======================= -->

<div class="container">
  <div class="chat-area" bind:this={scrollArea}>
    {#each messageList as msg (msg.id)}
      <ChatBubble {msg} />
    {/each}
  </div>

  <div class="input-area">
    <input
      type="text"
      bind:value={input}
      placeholder="メッセージを入力..."
      on:keydown={(e) => e.key === 'Enter' && send()}
    />
    <button on:click={send}>送信</button>
  </div>
</div>

<style>
  .container {
    display: flex;
    flex-direction: column;
    height: 100vh;
  }

  .chat-area {
    flex: 1;
    overflow-y: auto;
    padding: 16px;
  }

  .input-area {
    display: flex;
    gap: 12px;
    padding: 12px;
    border-top: 1px solid #333;
  }

  .input-area input {
    flex: 1;
    padding: 10px;
    background: #222;
    color: white;
    border: 1px solid #444;
    border-radius: 6px;
  }

  .input-area button {
    padding: 10px 20px;
    background: #56ccff;
    border: none;
    border-radius: 6px;
    cursor: pointer;
  }

  /* 入力フォーム */
.inputBar {
    display: flex;
    gap: 12px;
    padding: 16px;
    background: rgba(20, 20, 20, 0.9);  /* ← これで暗背景に浮かせる */
    border-top: 1px solid rgba(255, 255, 255, 0.1);
    backdrop-filter: blur(6px);
}

.inputBar input {
    flex: 1;
    padding: 12px 16px;
    border-radius: 12px;
    background: rgba(255, 255, 255, 0.08); /* ← グレーで視認性UP */
    color: white;
    border: 1px solid rgba(255,255,255,0.2);
    font-size: 16px;
}

.inputBar input::placeholder {
    color: rgba(255,255,255,0.5);  /* プレースホルダーが見えるように */
}

.inputBar button {
    padding: 10px 20px;
    border-radius: 12px;
    background: rgba(255,255,255,0.2);
    color: white;
    font-weight: bold;
    border: none;
    cursor: pointer;
    backdrop-filter: blur(4px);
}

.inputBar button:hover {
    background: rgba(255,255,255,0.3);
}

/* 入力欄が黒背景に溶ける問題の修正 */
.input-area {
  background: rgba(0, 0, 0, 0.4);   /* 半透明の黒で浮かせる */
  padding: 12px;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
}

.input-area textarea {
  background: rgba(30, 30, 30, 0.8); /* 入力欄の背景 */
  color: #fff;                      /* 文字を白く */
  padding: 10px 14px;
  border-radius: 8px;
  border: 1px solid rgba(255,255,255,0.2);
  width: 100%;
  resize: none;
  font-size: 1rem;
}

</style>
