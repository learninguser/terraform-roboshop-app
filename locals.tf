locals{
    name = "${var.project_name}-${var.environment}"
    subnet_id = element(split(",", var.subnet_ids), 0)
    current_time = formatdate("YYYY-MM-DD-hh-mm", timestamp())
}