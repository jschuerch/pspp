function ran0(seed)
    ! Park & Miller Random Generator
    integer seed,ia,im,iq,ir,mask,k
    real*8 ran0,am
    parameter (ia=16807,im=2147483647,am=1./im,iq=127773,ir=2836,mask=123459876)
    seed=ieor(seed,mask)
    k=seed/iq
    seed=ia*(seed-k*iq)-ir*k
    if (seed.lt.0) seed=seed+im
    ran0=am*seed
    seed=ieor(seed,mask)
    return
end

program MonteCarloOMP
    use omp_lib
    implicit none
    ! -----------------------------------------------Declare
    integer*4 i,tid
    integer*8 nofRedPoints,nofRedPoints_local,nofIterations
    real*8 x,y,pi,ran0
    integer*4, parameter :: numthreads = 4
    ! -----------------------------------------------Input
    !print*, "Enter number of iterations for approximation ..."
    !read*, nofIterations
    nofIterations = 10000000
    print*, "Number of iterations: ", nofIterations
    ! -----------------------------------------------Compute
    
    nofRedPoints = 0

    !$omp parallel private(nofRedPoints_local,x,y,i,tid) num_threads(numthreads)
    tid = omp_get_thread_num()
    nofRedPoints_local = 0
    do i=1, (nofIterations/numthreads)
        x = ran0(tid)
        y = ran0(tid)

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