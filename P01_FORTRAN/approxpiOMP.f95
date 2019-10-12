program MonteCarloOMP
    use omp_lib
    implicit none
    ! -----------------------------------------------Declare
    integer*8 i,nofRedPoints,nofRedPoints_local,nofIterations
    real*8 x,y,pi
    integer*4, parameter :: numthreads = 4
    ! -----------------------------------------------Input
    !print*, "Enter number of iterations for approximation ..."
    !read*, nofIterations
    nofIterations = 10000000
    print*, "Number of iterations: ", nofIterations
    ! -----------------------------------------------Compute
    
    nofRedPoints = 0

    !$omp parallel private(nofRedPoints_local,x,y,i) num_threads(numthreads)
    nofRedPoints_local = 0
    do i=1, (nofIterations/numthreads)
        x = rand(0)
        y = rand(0)

        if ((x**2+y**2) < 1) THEN
            nofRedPoints_local = nofRedPoints_local + 1
        endif
    enddo
    !$omp critical
     nofRedPoints = nofRedPoints + nofRedPoints_local
     !$omp end critical
    !$omp end parallel

    pi = float(nofRedPoints) / nofIterations * 4

    ! -----------------------------------------------Output
    print*, "The approximation of pi is: "
    print*, pi
end 