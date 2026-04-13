#!/usr/bin/env python
"""Django's command-line utility for administrative tasks."""
# Dòng shebang ở trên báo cho hệ điều hành biết đây là script Python.

import os  # Import thư viện os để tương tác với hệ điều hành (như set biến môi trường)
import sys # Import thư viện sys để lấy các tham số bạn gõ từ Terminal/Command Prompt


def main():
    """Run administrative tasks."""
    # Hàm chính để thực thi các lệnh quản trị của Django.
    
    # Thiết lập biến môi trường chỉ định nơi chứa cấu hình (settings) của dự án.
    # Ở đây, hệ thống sẽ tìm file settings.py nằm trong thư mục 'config'.
    os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings')
    
    try:
        # Thử import hàm thực thi lệnh từ lõi của Django
        from django.core.management import execute_from_command_line
    except ImportError as exc:
        # Bắt lỗi nếu không tìm thấy thư viện Django. 
        # Nguyên nhân thường là do bạn chưa cài Django bằng pip, 
        # hoặc (phổ biến nhất) là quên chưa bật môi trường ảo (virtual environment).
        raise ImportError(
            "Couldn't import Django. Are you sure it's installed and "
            "available on your PYTHONPATH environment variable? Did you "
            "forget to activate a virtual environment?"
        ) from exc
        
    # Lấy các câu lệnh bạn gõ trên Terminal truyền vào cho Django xử lý.
    # Ví dụ: gõ `python manage.py runserver`, sys.argv sẽ lấy chữ 'runserver' để chạy server.
    execute_from_command_line(sys.argv)


# Câu lệnh điều kiện này đảm bảo rằng hàm main() ở trên CHỈ được chạy 
# khi bạn chạy file này trực tiếp từ Terminal (VD: python manage.py ...).
# Nếu file này bị một file khác import vào, hàm main() sẽ không tự động chạy.
if __name__ == '__main__':
    main()
