<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>James Bond Data Portal</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://fonts.googleapis.com/css2?family=JetBrains+Mono:wght@400;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
    <link rel="stylesheet" href="{{ asset('css/style.css') }}">
</head>
<body class="public-body">

<header class="public-header">
    <nav class="public-nav">
        <h1 class="brand">James Bond Data Portal</h1>
        <div class="nav-links">
            <a href="/" class="nav-link">Home</a>
            <a href="/news" class="nav-link">News</a>
            <a href="/statistics" class="nav-link">Statistics</a>
            <a href="/infographics" class="nav-link">Infographics</a>
            <a href="/publications" class="nav-link">Publications</a>
        </div>
        <form action="/search" method="GET" class="search-bar">
            <input type="text" name="q" placeholder="Cari berita, infografik, publikasi..." value="{{ request('q') }}" required>
            <button type="submit">Cari</button>
        </form>
    </nav>
</header>

<main class="public-main">
    <div class="content-wrapper">
        @yield('content')
    </div>
</main>

</body>
</html>
