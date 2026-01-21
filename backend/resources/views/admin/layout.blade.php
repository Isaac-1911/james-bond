<!DOCTYPE html>
<html>
<head>
    <title>Admin Panel - James Bond</title>
    <link href="https://fonts.googleapis.com/css2?family=JetBrains+Mono:wght@400;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
    <link rel="stylesheet" href="{{ asset('css/admin1.css') }}">
</head>
<body class="admin-body">

<header class="admin-topbar">
    <div class="topbar-left">
        <span class="brand">James Bond Data Portal</span>
    </div>

    <nav class="topbar-nav">
        <a href="/admin" class="nav-link">Dashboard</a>
        <a href="/admin/news" class="nav-link">News</a>
        <a href="/admin/publications" class="nav-link">Publications</a>
        <a href="/admin/infographics" class="nav-link">Infographics</a>
        <a href="/admin/statistics" class="nav-link">Statistics</a>
    </nav>

    <form method="POST" action="/admin/logout" class="logout-form">
        @csrf
        <button type="submit" class="btn btn-danger logout-btn">
            Logout
        </button>
    </form>
</header>

<main class="admin-main">
    @yield('content')
</main>

</body>
</html>
