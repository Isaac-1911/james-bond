const API_BASE = "http://127.0.0.1/api"

function apiGet(endpoint) {
    return fetch(API_BASE + endpoint).then(res => res.json())
}
