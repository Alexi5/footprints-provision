#!/usr/bin/env bash

set -euo pipefail

function get_current_target_group()
{
    cd ./terraform;

    load_balancer_arn=$(terraform output production_elb_arn);

    aws elbv2 describe-listeners --load-balancer-arn "$load_balancer_arn" \
        | jq -r '.Listeners[1].DefaultActions[0].TargetGroupArn'
}
