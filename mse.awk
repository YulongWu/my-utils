BEIGN {
  sum_mse = 0.0
  sum_mae = 0.0
} {
  sum_i_mae = $1 - $2 < 0.0 ? $2-$1 : $1-$2
  sum_i_mse = sum_i_mae * sum_i_mae
  sum_mae += sum_i_mae
  sum_mse += sum_i_mse
} END {
  print 1.0*sum_mse/NR    
  print 1.0*sum_mae/NR    
}

