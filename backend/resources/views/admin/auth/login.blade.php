@extends('admin.auth.layout')

@section('content')
<div class="login-card">
    <div class="logo">
        <h2>Admin Login</h2>
        <p class="login-subtitle">James Bond Data Portal</p>
    </div>

    @if ($errors->any())
        <div class="alert-error">
            {{ $errors->first() }}
        </div>
    @endif

    <form method="POST" action="/admin/login">
        @csrf

        <div class="form-group">
            <label>Email</label>
            <input type="email" name="email" required autofocus placeholder="Enter your email">
        </div>

        <div class="form-group">
            <label>Password</label>
            <input type="password" name="password" required placeholder="Enter your password">
        </div>

        <button class="btn btn-primary btn-full" type="submit">
            Access Portal
        </button>
    </form>
</div>
@endsection
