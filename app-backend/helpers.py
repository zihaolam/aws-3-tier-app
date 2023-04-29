from flask import Request, abort

def get_path_param(request: Request, param_name: str):
    if request.view_args is None:
        return abort(code=422)
    
    return request.view_args[param_name]