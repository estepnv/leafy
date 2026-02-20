# Migration from Travis CI to GitHub Actions

## Changes Made

### 1. GitHub Actions Workflow (`.github/workflows/ci.yml`)
- Created a new CI workflow that tests against multiple Ruby versions
- **Ruby versions tested**: 2.2, 2.3, 2.4, 2.5, 2.6, 2.7, 3.0, 3.1, 3.2, 3.3, head, jruby-9.4
- Set up PostgreSQL and MySQL services (matching your docker-compose setup)
- Integrated Code Climate test reporter for coverage (only on Ruby 3.3)
- Allow failures for Ruby head and JRuby (won't block CI)

### 2. Updated `leafy.gemspec`
- Improved ActiveRecord version selection based on Ruby version:
  - Ruby 2.2-2.4: ActiveRecord ~> 5.2
  - Ruby 2.5-2.6: ActiveRecord ~> 6.0
  - Ruby 2.7+: ActiveRecord ~> 6.1
- Added pg version constraint `< 2.0` for better compatibility

### 3. Updated `Gemfile`
- Made Ruby 3.4+ bundled gems conditional (only loaded when RUBY_VERSION >= 3.4.0)
- This ensures older Ruby versions don't have issues with gems they don't need

### 4. Updated `spec/spec_helper.rb`
- Made bundled gem requires conditional for Ruby 3.4+
- Ensures compatibility across all Ruby versions

### 5. Updated `README.md`
- Replaced Travis CI badge with GitHub Actions badge

## Testing the Setup

### Local Testing
Ensure tests still pass locally:
```bash
bundle install
bundle exec rspec
```

### Testing with Different Ruby Versions (using Docker)
```bash
# Ruby 2.7
docker run -it --rm -v $(pwd):/app -w /app ruby:2.7 bash -c "bundle install && bundle exec rspec"

# Ruby 3.0
docker run -it --rm -v $(pwd):/app -w /app ruby:3.0 bash -c "bundle install && bundle exec rspec"

# Ruby 3.1
docker run -it --rm -v $(pwd):/app -w /app ruby:3.1 bash -c "bundle install && bundle exec rspec"
```

## What to Do Next

1. **Commit the changes**:
   ```bash
   git add .github/workflows/ci.yml
   git add Gemfile leafy.gemspec spec/spec_helper.rb README.md
   git rm .travis.yml
   git commit -m "Migrate from Travis CI to GitHub Actions"
   ```

2. **Push to GitHub**:
   ```bash
   git push origin master
   ```

3. **Verify the workflow**:
   - Go to your repository on GitHub
   - Click on the "Actions" tab
   - You should see the CI workflow running
   - Check that tests pass for all Ruby versions

## Notes

- The workflow runs on every push to `master`/`main` branches and on pull requests
- Ruby 2.2-2.4 may have limitations with newer gems, so ActiveRecord 5.2 is used
- Ruby 3.4+ requires explicit bundled gem declarations (erb, logger, mutex_m, etc.)
- Code Climate coverage is only uploaded from Ruby 3.3 builds to avoid duplicates

## Cleanup

You can safely delete `.travis.yml` after confirming GitHub Actions is working.
