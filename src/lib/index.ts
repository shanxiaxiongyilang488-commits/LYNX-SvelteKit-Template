// place files you want to import through the `$lib` alias in this folder.
// src/lib/index.ts

export type ChatMessage = {
  id: string;
  sender: string;
  text: string;
  timestamp?: string;
};
