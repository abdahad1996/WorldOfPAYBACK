## CI/CD

I used `GitHub Actions` to automate the CI/CD pipeline to ensure code changes are built and tested automatically. The pipeline runs every time commits are pushed to the main branch. It performs the following tasks:
2. Builds the app and runs all tests to ensure code changes do not break existing functionality.

## Security

### API key for Google Places API

For security purposes, I stored the `API_KEY` in a plist to prevent from being leaked in the source code by adding the file in the `.gitignore`. This ensures the file only exists locally on my device, thus preventing any possible leakage to an attacker who could make requests on my behalf for free.

you can add in your environment variable in Github action but the best way to secure keys are to not have them on the app.
