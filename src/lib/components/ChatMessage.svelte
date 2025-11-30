<script lang="ts">
  import ChatBubble from "./ChatBubble.svelte";
  import type { ChatMessage } from "$lib/types";

  export let msg: ChatMessage;

  // アバターパス
  const avatarMap: Record<string, string> = {
    user: "/avatars/user.png",
    muryi: "/avatars/muryi.png",
    piona: "/avatars/piona.png",
    menoa: "/avatars/menoa.png",
    ciel: "/avatars/ciel.png"
  };

  const avatar = avatarMap[msg.sender] ?? "/avatars/user.png";
  const isUser = msg.sender === "user";
</script>

<ChatBubble
  message={msg.text}
  sender={msg.sender}
  avatar={avatar}
  {isUser}
/>
