function pyclean --description 'Clean Python cache and temporary files'
    find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null
    and find . -type d -name "*.egg-info" -exec rm -rf {} + 2>/dev/null
    and find . -type d -name ".idea" -exec rm -rf {} + 2>/dev/null
    and find . -type d -name ".mypy_cache" -exec rm -rf {} + 2>/dev/null
    and find . -type d -name ".pytest_cache" -exec rm -rf {} + 2>/dev/null
    and find . -type d -name ".ruff_cache" -exec rm -rf {} + 2>/dev/null
    and find . -type d -name ".tox" -exec rm -rf {} + 2>/dev/null
    and find . -type d -name ".coverage" -exec rm -rf {} + 2>/dev/null
    and find . -type f -name ".coverage" -delete 2>/dev/null
    and find . -type f -name "*.pyc" -delete 2>/dev/null
    echo "Python cache and temporary files cleaned!"
end
