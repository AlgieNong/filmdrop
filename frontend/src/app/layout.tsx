import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "FilmDrop / 映投",
  description: "定时给你推送一部值得看的电影",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="zh-CN">
      <body className="min-h-screen bg-gray-50 text-gray-900">
        {children}
      </body>
    </html>
  );
}
