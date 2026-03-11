export default function Home() {
  return (
    <main className="min-h-screen bg-gradient-to-br from-red-500 to-teal-500">
      <div className="container mx-auto px-4 py-16 text-center text-white">
        <h1 className="text-5xl font-bold mb-4">🐱 Meow Metrics</h1>
        <p className="text-xl opacity-90">Urban Cat Colony Management Platform</p>
        <div className="mt-12 space-x-4">
          <a href="/login" className="btn btn-primary">Sign In</a>
          <a href="/register" className="btn btn-outline text-white">Register</a>
        </div>
      </div>
    </main>
  );
}
