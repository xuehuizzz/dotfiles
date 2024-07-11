"""该脚本为格式化输出不必要异常功能.
自动加载配置： 在您的 Python 程序或项目中，在启动时自动加载这个配置文件。一种简单的方法是在您的主程序或入口文件中导入这个配置文件
pip install pretty-errors
"""
import sys

import pretty_errors

pretty_errors.configure(
    separator_character='',
    filename_display=pretty_errors.FILENAME_EXTENDED,  # 置文件名的显示方式为扩展模式，可能包括完整路径等详细信息
    line_number_first=True,  # 异常信息中显示行号在前面
    line_color=pretty_errors.RED + '> ' + pretty_errors.default_config.line_color,
    # 设置行号显示颜色为红色，并在行号前添加 > 符号
    code_color='  ' + pretty_errors.default_config.line_color,  # 设置代码行的颜色，前面添加两个空格
    truncate_code=True,  # 截断代码以适应屏幕宽度
    display_locals=True,  # 显示局部变量信息
)
pretty_errors.blacklist(sys.executable)  # 黑名单模式，忽略指定路径下的错误信息
