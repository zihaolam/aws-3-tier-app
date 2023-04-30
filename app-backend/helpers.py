from flask import Request, abort
from flask_sqlalchemy import SQLAlchemy
from sqlalchemy import event, join, select, text
from sqlalchemy.dialects.mysql import dialect
from sqlalchemy.orm.session import ORMExecuteState, Session
from sqlalchemy import Executable
from sqlalchemy.orm import loading, with_polymorphic

def get_path_param(request: Request, param_name: str):
    if request.view_args is None:
        return abort(code=422)
    
    return request.view_args[param_name]

def attach_ip_address_to_queries(db: SQLAlchemy):
    def get_query_digest(orm_state: ORMExecuteState):
        if orm_state.statement.is_select:
            orm_state.update_execution_options(populate_existing=True)
            orm_state.statement = orm_state.statement
        
    event.listen(db.session, 'do_orm_execute', get_query_digest)