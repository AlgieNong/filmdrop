export default function MovieDetailPage({ params }: { params: { id: string } }) {
  return (
    <main className="mx-auto max-w-4xl px-4 py-8">
      <h1 className="mb-6 text-2xl font-bold">电影详情</h1>
      <p className="text-gray-500">电影 ID: {params.id}</p>
      <p className="text-gray-500">详情页面开发中</p>
    </main>
  );
}
