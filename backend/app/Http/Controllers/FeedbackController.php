<?php
namespace App\Http\Controllers;

use App\Models\Feedback;
use Illuminate\Http\Request;

class FeedbackController extends Controller
{
    public function store(Request $request)
    {
        $validated = $request->validate([
            'rating' => 'required|integer|min:1|max:5',
            'job' => 'nullable|string|max:50',
            'tags' => 'nullable|array',
            'tags.*' => 'string|max:50',
            'message' => 'nullable|string|max:1000',
        ]);

        $feedback = Feedback::create([
            'rating' => $validated['rating'],
            'job' => $validated['job'] ?? null,
            'tags' => $validated['tags'] ?? null,
            'message' => $validated['message'] ?? null,
            'user_agent' => $request->userAgent(),
            'ip_address' => $request->ip(),
        ]);

        return response()->json([
            'status' => 'success',
            'message' => 'Feedback berhasil dikirim',
            'data' => $feedback,
        ], 201);
    }
}
