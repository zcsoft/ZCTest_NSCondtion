ZCTest_NSCondtion
=================

iOS thread synchronization test, using NSCondtion


iOS中实现多线程技术有很多方法。
这里说说使用NSCondition实现多线程同步的问题，也就是解决生产者消费者问题（如收发同步等等）。

问题流程如下：
    消费者取得锁，取产品，如果没有，则wait，这时会释放锁，直到有线程唤醒它去消费产品；
    生产者制造产品，首先也要取得锁，然后生产，再发signal，这样可唤醒wait的消费者。

这里需要注意wait和signal的问题：
    1: 其实，wait函数内部悄悄的调用了unlock函数（猜测，有兴趣可自行分析），也就是说在调用wati函数后，这个NSCondition对象就处于了无锁的状态，这样其他线程就可以对此对象加锁并触发该NSCondition对象。当NSCondition被其他线程触发时，在wait函数内部得到此事件被触发的通知，然后对此事件重新调用lock函数（猜测），而在外部看起来好像接收事件的线程（调用wait的线程）从来没有放开NSCondition对象的所有权，wati线程直接由阻塞状态进入了触发状态一样。这里容易造成误解。
    2: wait函数并不是完全可信的。也就是说wait返回后，并不代表对应的事件一定被触发了，因此，为了保证线程之间的同步关系，使用NSCondtion时往往需要加入一个额外的变量来对非正常的wait返回进行规避。
    3: 关于多个wait时的调用顺序，测试发现与wait执行顺序有关。具体请查阅文档。

