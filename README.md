# TAT Card AutoPost

Flutter project for Android, Windows and browser-based Web deployment.

## Web version

The repository now includes a Flutter Web target and a GitHub Actions workflow.
On every push to `main`, GitHub builds the web app and deploys it to GitHub Pages.

Expected Pages URL for the repository `Tahidultech/tat-card_up`:

`https://tahidultech.github.io/tat-card_up/`

### Web feature notes

- Latest RSS, search, manual card editing, Bengali fonts and JPEG export are adapted for browser use.
- Editor preferences and the license key are stored in browser local storage through `shared_preferences`. They are stored separately per browser/device.
- Image import uses browser file selection and in-memory image bytes.
- The Web `Via URL` action opens the entered article link in a new tab. Browser same-origin security prevents this app from silently reading cross-origin redirects and article metadata in the same way as the Android hidden WebView. Full automatic URL resolution needs a trusted server-side metadata/redirect endpoint with CORS configured.
- Buffer publishing and ImgBB upload credentials have been removed from the client source. Do not put Buffer or ImgBB secrets in a public repository or a browser build. These operations need a server-side proxy before they can safely be enabled on the public Web app.
- The Cloudflare license endpoint must allow browser CORS requests from the deployed Pages origin, including an `OPTIONS` preflight response. Verify this endpoint before publishing.

## Publish on GitHub Pages

1. Push this project to the repository's `main` branch.
2. Open the repository on GitHub.
3. Go to **Settings → Pages**.
4. Under **Build and deployment**, select **Deploy from a GitHub Actions workflow**.
5. Open the **Actions** tab and wait for **Deploy Flutter Web to GitHub Pages** to finish successfully.
6. Open `https://tahidultech.github.io/tat-card_up/`.

The workflow currently uses `/tat-card_up/` as the base path. If the repository name changes, update `--base-href` in `.github/workflows/deploy-web.yml`.

## Build locally

```bash
flutter pub get
flutter build web --release --base-href /tat-card_up/
```

Output: `build/web/`.

## Android build

```bash
flutter build apk --release
```

## Security

The previous source contained Buffer and ImgBB API credentials directly in `lib/buffer_service.dart`. Those values have been removed from this Web-ready source. **Revoke/rotate the old credentials in their provider dashboards immediately**, because credentials included in source code or shared archives should be considered exposed. Never store API secrets in Flutter Web code or GitHub commits.
