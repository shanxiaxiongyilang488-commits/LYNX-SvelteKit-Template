import { writable } from "svelte/store";

// -----------------------------
// メッセージ型
// -----------------------------
export type ChatMessage = {
  id: string;
  sender: string;   // muryi / piona / meno / ciel / user / sys
  text: string;
};

// -----------------------------
// メッセージストア
// -----------------------------
export const messages = writable<ChatMessage[]>([]);

// -----------------------------
// メッセージ追加
// -----------------------------
export function addMessage(sender: string, text: string) {
  messages.update((list) => [
    ...list,
    {
      id: crypto.randomUUID(),
      sender,
      text
    }
  ]);
}

// -----------------------------
// AIメッセージ送信（現在はダミー）
// -----------------------------
export async function sendAIMessage(userText: string) {
  // 本来は API に渡す
  // いまはダミー会話で返す
  const reply = `（AI仮返答）${userText}`;

  addMessage("ciel", reply); // ← 表示テスト用に "ciel" を AI役に
}

// -----------------------------
// 初期メッセージ（必要なら）
// -----------------------------
export function initSystemMessage() {
  addMessage("sys", "SYSTEM起動完了：チャット準備OK");
}
