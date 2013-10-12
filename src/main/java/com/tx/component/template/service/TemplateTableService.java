/*
 * 描          述:  <描述>
 * 修  改   人:  brady
 * 修改时间:  2013-10-12
 * <修改描述:>
 */
package com.tx.component.template.service;

import com.tx.component.template.model.TemplateTable;
import com.tx.component.template.model.TemplateTableType;

/**
 * 模板业务层<br/>
 * <功能详细描述>
 * 
 * @author  brady
 * @version  [版本号, 2013-10-12]
 * @see  [相关类/方法]
 * @since  [产品/模块版本]
 */
public interface TemplateTableService {
    
    public String insertTemplateTable(TemplateTable tamplateTable);
    
    public TemplateTable findTemplateTableById(String templateId);
    
    public TemplateTable findTemplateTableByNameAndTableType(
            String templateName, TemplateTableType tableType);
    
}
